class MainController < ApplicationController
  def home
    unless current_user.is_admin_or_extenda?
      @date = Time.parse("#{CONFIG[:admin][:preferences][:event_start_day]} #{CONFIG[:admin][:preferences][:event_day_start_at]}")
      @days = 3
      @meetings = current_user.meetings(@date, @days)
    end
  end
end
