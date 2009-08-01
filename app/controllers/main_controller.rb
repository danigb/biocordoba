class MainController < ApplicationController
  def home
    unless current_user.is_admin_or_extenda?
      @date = Time.parse("2009-09-22 19:00")
      @days = 3
      @events = current_user.meetings(@date, @days)
    end
  end
end
