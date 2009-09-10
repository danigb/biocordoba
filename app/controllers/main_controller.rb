class MainController < ApplicationController
  def home
    unless current_user.is_admin_or_extenda?
      @date = Event.start_day_and_hour
      @days = Event.duration
      @meetings = current_user.meetings(@date, @days)
    end
  end

  def email
    @message = Message.first 
    @sender = @user = User.find_by_login("elena")
    render :file => "user_mailer/#{params[:id]}", :layout => "email"
  end
end
