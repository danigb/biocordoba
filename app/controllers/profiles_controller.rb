class ProfilesController < ApplicationController
  def show
    @profile = Profile.find(params[:id])
    respond_to do |format|
      format.html{ }
      format.js{
        render :layout => false
      }
    end
  end

  def commercial_profile
    respond_to do |format|
      format.js{
        @profile = Profile.find_by_company_name(params[:id])
        if @profile && !@profile.commercial_profile.blank?
          render :text => "<p class='enviar'>PERFIL COMERCIAL</p>" + @profile.commercial_profile
        else
          render :text => "<div class='pink'>Sin información en su perfil comercial</div>" 
        end
      }
    end
  end
end
