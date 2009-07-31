class UsersController < ApplicationController
  def search
    # unless (buyers = User.buyers).blank?
      # @search = User.search(params[:search]).roles_title_like_any(["international_buyer", "national_buyer", "exhibitor"])
      @search = User.search(params[:search])
      @search.roles_title_like_any(current_user.is_exhibitor? ? ["international_buyer", "national_buyer"] : ["exhibitor"]) 
      # FIXME, no me funciona en servidor @users = @search.ascend_by_profile_company_name.all(:include => [{:profile => :sector}, :roles])
      @users = @search.all(:include => [{:profile => :sector}, :roles])
      @users_by_sector = @users.group_by{|u| u.profile.sector.name }
    # end
  end
end
