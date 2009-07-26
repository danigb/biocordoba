class UsersController < ApplicationController
  def search
    @search = User.search(params[:search])
    @users = @search.ascend_by_profile_company_name.all
    @users_by_sector = @users.group_by{|u| u.profile.sector.name }
  end
end
