class UsersController < ApplicationController
  def search
    unless params[:search].blank?
      @search = User.search(params[:search])
      @search.roles_title_like_any(current_user.is_exhibitor? ? ["international_buyer", "national_buyer"] : ["exhibitor"]) 
      @users = @search.all(:include => [{:profile => :sectors}, :roles])
      @users_by_sector = @users.group_by{|u| u.profile.sectors.name }
    end
  end

  def index
    @roles = Role.find(:all, :include => :users)
  end

  def new
    @user = User.new
  end

  def new_admin_extenda
    @user = User.new
  end
 
  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.password = Haddock::Password.generate(10)

    unless @user.profile.company_name.blank?
      @user.login = @user.profile.company_name.normalize 
    end
    
    # Check that user extenda only can create international buyer
    @extenda_valid = current_user.is_extenda? && !@user.is_international_buyer? ? false : true

    if params[:default_preferences] == "1"
      @user.preference.delete if @user.preference
      @user.preference = Preference.first
    end

    success = @user && @extenda_valid && @user.save 
    if success && @user.errors.empty?
      UserMailer.deliver_welcome_email(current_user, @user)

      flash[:notice] = "El usuario <b>#{@user.login}</b> ha sido registrado con éxito."
      if params[:continue]
        redirect_to signup_path
      else
        redirect_to users_path
      end
    else
      flash.now[:error]  = "Existen errores en el formulario."
      render :action => 'new'
    end
  end

  def create_admin_extenda
    @user = User.new(params[:user])
    @user.password = Haddock::Password.generate(10)

    unless @user.login.blank?
      @user.build_profile(:company_name => @user.login, :sector_id => 1)
    end

    if @user.save
      UserMailer.deliver_welcome_email(current_user, @user)

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
      @user.preference.delete
      @user.preference = Preference.first
    else
      if params[:user][:preference_attributes][:id] == "1" 
        # Quitamos la id del hash para que no pise el master password
        params[:user][:preference_attributes].delete("id")
      end
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuario modificado correctamente"
      redirect_to users_path
    else
      flash[:error] = "Existen errores en el formulario"
      render :action => 'edit'
    end
  end


  def type
    @role = Role.find_by_title(params[:type])
    @users = @role.users.paginate(:per_page => 20, :page => params[:page])
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
