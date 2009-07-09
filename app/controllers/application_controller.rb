# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_gettext_locale, :login_required

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  def set_gettext_locale
    FastGettext.text_domain = 'app'
    FastGettext.available_locales = ['es','en'] #all you want to allow
    # FastGettext.default_locale = 'es'
    super
  end
end
