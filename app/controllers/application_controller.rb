# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  helper :breadcrumbs

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :login_required

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password


  # Redirecciona a la zona concreta dependiendo del rol
  def redirect_to_zone
    if current_user
      if current_user.is_admin?
        redirect_to admin_path
      elsif current_user.is_extenda?
        redirect_to extenda_path
      else
        redirect_to home_path
      end
    end
  end

end
