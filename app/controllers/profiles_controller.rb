class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    respond_to do |format|
      format.html{
      }
      format.js{
        render :layout => false
      }
    end
  end

end
