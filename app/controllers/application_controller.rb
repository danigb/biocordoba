# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  helper :breadcrumbs

  helper :all # include all helpers, all the time
  # protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :login_required

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  private

  def redirect_back_or(path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to path
  end

  protected

  def permission_denied
    flash.now[:notice] = "Acceso denegado"
    return redirect_back_or("/")
  end

end
