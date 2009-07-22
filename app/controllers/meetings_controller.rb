class MeetingsController < ApplicationController
  before_filter :login_required

  def new
    @date = Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    @host = User.find(params[:host_id])
    @guest = User.find(params[:guest_id])

    @meeting = Meeting.new
  end

  def create 
    @meeting = Meeting.new(params[:meeting])
    @meeting.starts_at = Time.parse("2009-09-22 #{@meeting.starts_at.strftime("%k:%M")}")
    @meeting.ends_at = @meeting.starts_at + current_user.preference.meetings_duration.minutes
    @meeting.host = current_user

    @meeting.save!
  end
end
