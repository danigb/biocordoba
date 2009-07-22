class MeetingsController < ApplicationController
  def new
    @date = Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    @days = 1
    @host = User.find(params[:host_id])
    @guest = User.find(params[:guest_id])
  end
end
