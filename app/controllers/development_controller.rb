class DevelopmentController < ApplicationController
  skip_before_filter :login_required
  caches_page :changelog

  def changelog
  end
end
