class MainController < ApplicationController
  def home
    unless current_user.is_admin_or_extenda?
      @date = Event.start_day_and_hour
      @days = Event.duration
      @meetings = current_user.meetings(@date, @days)
    end
  end
end
