class MainController < ApplicationController
  skip_before_filter :login_required, :only => :index
  before_filter :redirect_to_zone, :only => :index

  def index
    render :layout => 'extended'
  end

  def home
    @date = Time.parse("2009-09-22 19:00")
    @days = 3
    @events = current_user.meetings(@date, @days)
  end
end
