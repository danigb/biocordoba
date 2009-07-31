class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    @user = @profile.user
    respond_to do |format|
      format.html{
        render :layout => current_user.is_admin_or_extenda? ? "extended" : 'application'
      }
      format.js{
        render :layout => false
      }
    end
  end

end
