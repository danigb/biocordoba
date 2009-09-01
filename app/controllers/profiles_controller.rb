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
        @user = User.find_by_login(params[:id])
        @profile = @user.profile if @user
        if @profile && !@profile.commercial_profile.blank?
          render :text => "<p class='enviar'>PERFIL COMERCIAL</p>" + @profile.commercial_profile
        else
          render :text => "<div class='pink'>Sin información en su perfil comercial</div>" 
        end
      }
    end
  end

  def new_external
    respond_to do |format|
      format.html{ }
      format.js{
        render :layout => false
      }
    end
  end

  #Creamos un usuario externo solo usando su company_name, su estado inicial será desactivado
  def create_external
    unless params[:profile][:company_name].present?
      flash[:error] = "Debe indicar el nombre del usuario"
      redirect_to :back and return
    end

    @user = User.new(:login => params[:profile][:company_name].normalize, :state => 'disabled', 
      :password => 'secret', :external => true)
    @user.roles << Role.find_by_title("national_buyer")

    if @user.save
      @profile = Profile.new(:user_id => @user.id, :company_name => params[:profile][:company_name])
      @profile.sectors << Sector.first
      @profile.save
      redirect_to meeting_into_and_path(current_user.login, @user.login)
    end
  end
end
