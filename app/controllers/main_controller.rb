class MainController < ApplicationController
  before_filter :redirect_to_zone

  def home
    @date = Time.parse("2009-09-22 19:00")
    @days = 3
    @events = current_user.meetings(@date, @days)
  end
end
