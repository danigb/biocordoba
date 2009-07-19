class UsersController < ApplicationController
  skip_before_filter :login_required

  # render new.rhtml
  def new
    @user = User.new
    @auto_password = true
  end
 
  def create
    @user = User.new(params[:user])
    
    if params[:auto] && params[:auto][:password]
      @user.password = @user.password_confirmation = Haddock::Password.generate(10)
      @auto_password = true
    else
      @auto_password = false
    end
      
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      redirect_back_or_default('/')
      # flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
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
