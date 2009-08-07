class EventDaysController < ApplicationController
  def show
    @day = Date.parse(params[:date])
    @meetings = current_user.meetings(@day, 1)
  end
end
