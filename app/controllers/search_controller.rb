
class SearchController < ApplicationController
  def show_users
    find_users
  end
  
  def print_users
    find_users
    render :layout => 'print'
  end

  private
  def find_users
    @sectors = Sector.find(:all, :select => 'id, name')
    @search = User.search
    if params[:search]
      @search.profile_company_name_like(params[:search][:profile_company_name_like].gsub("."," ")) if params[:search][:profile_company_name_like].present?
      @search.profile_sectors_id_equals(params[:search][:profile_sectors_id_equals]) if params[:search][:profile_sectors_id_equals].present?
    end
    @search.roles_title_like_any(current_user.is_exhibitor? ? ["international_buyer", "national_buyer"] : ["exhibitor"])
    @search.state_equals("enabled")
    @users = @search.paginate(:include => [{:profile => [:sectors, :country]}, :roles], :per_page => 20, :page => params[:page])
    @users_by_sector = @users.group_by{|u| u.profile.sectors.first.name }
    @users_by_sector = @users.group_by{|u| u.profile.country.name }
  end
end