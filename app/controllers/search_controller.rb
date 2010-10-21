
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
    profile_company_name = params[:search] ? params[:search][:profile_company_name_like] : ''
    @search = User.search()
    @search.profile_company_name_like(profile_company_name.gsub("."," "))
    @search.roles_title_like_any(current_user.is_exhibitor? ? ["international_buyer", "national_buyer"] : ["exhibitor"])
    @search.state_equals("enabled")
    @users = @search.all(:include => [{:profile => [:sectors, :country]}, :roles])
    @users_by_sector = @users.group_by{|u| u.profile.sectors.first.name }
    @users_by_sector = @users.group_by{|u| u.profile.country.name }
  end
end