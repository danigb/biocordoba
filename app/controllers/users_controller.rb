class UsersController < ApplicationController
  def search
    @search = User.search(params[:search])
    @users = @search.all
  end
end
