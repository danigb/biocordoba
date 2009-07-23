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

    if @meeting.save
      flash[:notice] = "La cita se ha guardado con éxito."
      redirect_to home_path
    else
      flash.now[:error] = "No se ha guardado la cita. Ya tienes un cita con este comprador."

      # Reloading vars
      params[:host_id] = current_user.id
      params[:guest_id] = params[:meeting][:guest_id]
      new

      render :action => 'new'
    end
  end

  def index
    @international_buyers = Role.find_by_title('international_buyer').users
    @national_buyers = Role.find_by_title('national_buyer').users
  end
end
