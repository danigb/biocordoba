class UsersController < ApplicationController
  def search
    @search = User.search(params[:search])
    @users = @search.ascend_by_profile_company_name.all
  end
end
