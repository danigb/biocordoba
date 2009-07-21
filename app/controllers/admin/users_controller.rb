class Admin::UsersController < ApplicationController
  layout "admin"
  skip_before_filter :login_required

  def index
    @roles = Role.find(:all, :include => :users)
  end

  def new
    @user = User.new
    @auto_password = true
  end
 
  def edit
    @user = User.find(params[:id])
  end

  #Aquí debeactualizar profile y preference también haciendo uso de nested forms
  def update
    @user = User.find(params[:id])
    if params[:default_preferences] == "1"
      @user.preference.delete
      @user.preference = Preference.first
    else
      if params[:user][:preference_attributes][:id] == "1" 
        #Quitamos la id del hash para que no pise el master password
        params[:user][:preference_attributes].delete("id")
      end
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuario modificado correctamente"
      redirect_to admin_users_path
    else
      flash[:error] = "Existen errores en el formulario"
      render :action => 'edit'
    end
  end

  def create
    @user = User.new(params[:user])
    
    if params[:auto] && params[:auto][:password]
      @user.password = @user.password_confirmation = Haddock::Password.generate(10)
      @auto_password = true
    else
      @auto_password = false
    end
    @password = @user.password

    @extenda_valid = current_user.is_extenda? && !@user.is_international_buyer? ? false : true

    if params[:default_preferences] == "1"
      @user.preference.delete
      @user.preference = Preference.first
    end

    success = @user && @extenda_valid && @user.save 
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session

      UserMailer.deliver_welcome_email(current_user, @user, @password)

      flash[:notice] = "El usuario <b>#{@user.login}</b> ha sido registrado con éxito."
      if params[:continue]
        redirect_to signup_path
      else
        redirect_to admin_users_path
      end
    else
      flash.now[:error]  = "Existen errores en el formulario."
      render :action => 'new'
    end
  end

  def type
    @role = Role.find_by_title(params[:type])
    @users = @role.users
  end

  def destroy
    user = User.find(params[:id])

    # You should not delete yourself or first user (admin)
    if user == current_user || user == User.first
      render :text => current_user.login and return
      flash[:error] = "Error. No puedes eliminar este usuario."
    else
      user.destroy
      flash[:notice] = "Usuario eliminado con éxito"
    end

    redirect_to type_users_path(params[:type])
  end
end
