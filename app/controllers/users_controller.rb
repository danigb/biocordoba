class UsersController < ApplicationController
  access_control :DEFAULT => '(admin | extenda)', :search => '!admin'

  def index
    @roles = Role.all
    render :layout => "application"
  end

  def new
    @user = User.new
  end

  def new_admin_extenda
    @user = User.new
    @user.role_id = params[:user][:role_id] if params[:user]
  end
 
  def edit
    @user = User.find(params[:id])
    @preference = @user.preference
  end

  def create
    @user = User.new(params[:user])
    # @user.password = Haddock::Password.generate(10)
    @user.password = String.password

    unless @user.profile.company_name.blank?
      @user.login = @user.profile.company_name.normalize 
    end
    
    # Check that user extenda only can create international buyer
    @extenda_valid = current_user.is_extenda? && !@user.is_international_buyer? ? false : true

    if params[:default_preferences] == "1"
      case(params[:user][:role_id])
      when("5") #Expositor
        @user.preference = Preference.general_for_exhibitor.first
      when("3") #Comprador nacional
        @user.preference = Preference.general_for_national_buyer.first
      when("4") #Comprador internacional
        @user.preference = Preference.general_for_international_buyer.first
      end
    end

    success = @user && @extenda_valid && @user.save 
    if success && @user.errors.empty?
      UserMailer.send_later(:deliver_welcome_email, @user) if @user.email

      flash[:notice] = "El usuario <b>#{@user.login}</b> ha sido registrado con éxito."
      if params[:continue]
        redirect_to signup_path
      else
        redirect_to users_path
      end
    else
      @preference = Preference.new(params[:user][:preference_attributes])
      flash.now[:error]  = "Existen errores en el formulario."
      render :action => 'new'
    end
  end

  def create_admin_extenda
    @user = User.new(params[:user])
    @user.password = String.password

    if @user.save
      unless @user.login.blank?
        @profile = @user.build_profile(:company_name => @user.login)
        @profile.sectors << Sector.first
        @profile.save
      end
      UserMailer.deliver_welcome_email(@user)

      flash[:notice] = "El usuario <b></b> ha sido creado con éxito."
      redirect_to users_path
    else
      flash.now[:error] = "Existen errores en el formulario."
      render :action => 'new_admin_extenda'
    end
  end

  # Aquí debe actualizar profile y preference también haciendo uso de nested forms
  def update
    @user = User.find(params[:id])
    params[:user][:profile_attributes][:sector_ids] ||= [] #HABTM checkboxes

    if params[:default_preferences] == "1"
      @user.preference.delete if @user.preference && @user.preference.id > 3
      if @user.is_exhibitor?
        @user.preference = Preference.general_for_exhibitor.first
      elsif @user.is_national_buyer?
        @user.preference = Preference.general_for_national_buyer.first
      elsif @user.is_international_buyer?
        @user.preference = Preference.general_for_international_buyer.first
      end
    else
      if params[:user][:preference_attributes][:id].to_i <= 3
        # Quitamos la id del hash para que no pise el master configuration
        params[:user][:preference_attributes].delete("id")
      end
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuario modificado correctamente."
      redirect_to users_path
    else
      @preference = @user.preference
      flash[:error] = "Existen errores en el formulario."
      render :action => 'edit'
    end
  end


  def type
    @role = Role.find_by_title(params[:type])
    @users = @role.users.paginate(:per_page => 20, :page => params[:page], :order => params[:sort])
    render :layout => "admin"
  end

  def destroy
    user = User.find(params[:id])

    # You should not delete yourself or first user (admin)
    if user == current_user || user == User.first
      render :text => current_user.login and return
      flash[:error] = "Error. No puedes desactivar este usuario."
    else
      user.disable!
      UserMailer.send_later(:deliver_user_disabled, user) if user.email
      flash[:notice] = "Usuario eliminado con éxito."
    end

    redirect_to type_users_path(params[:type])
  end




def print
  redirect_to root_path and return if (current_user.is_extenda? && !["international_buyer", "extenda"].include?(params[:type]))
  @users = User.find(:all, :include => [:profile, :roles], :order => "profiles.company_name",
    :conditions => ["roles.title = ?", params[:type]])

  @users = @users.group_by{|u| u.roles.first.title }
  render :layout => false
end

def send_password
  @user = User.find(params[:id])
  if @user
    @user.update_attribute(:password, String.password) if params[:regenerate]
    if @user.email.present?
      UserMailer.send_later(:deliver_remember_password, @user)
      flash[:notice] = "Contraseña enviada"
    else
      flash[:notice] = "Atención: No se le puede enviar pues no tiene definida una cuenta de email."
    end
  else
    flash[:error] = "Error al enviar la contraseña"
  end
  redirect_to :back
end
end
