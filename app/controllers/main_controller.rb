class MainController < ApplicationController
  def home
    unless current_user.is_admin_or_extenda?
      @date = Event.start_day_and_hour
      @days = Event.duration
      @meetings = current_user.meetings(@date, @days)
    end
  end

  def email
    @date = Event.start_day_and_hour
    @user = User.find_by_login("cocacola")
    @meetings = @user.meetings(@date,1)
    @meeting= @meetings.first 
    @message = Message.first 
    render :file => "meeting_mailer/#{params[:id]}", :layout => "email"
  end
end
