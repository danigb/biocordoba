class MeetingsController < ApplicationController
  before_filter :login_required
  
  def index
    @international_buyers = Role.find_by_title('international_buyer').users
    @national_buyers = Role.find_by_title('national_buyer').users
  end

  def new
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    @host = User.find(params[:host_id])
    @guest = User.find(params[:guest_id])
    valid_date?(@date)
    valid_host_and_guest?(@host, @guest)

    @meeting = Meeting.between(@host, @guest)
  end

  def create 
    @meeting = Meeting.new(params[:meeting])
    @meeting.starts_at = Time.parse("#{params[:date][:start]} #{@meeting.starts_at.strftime("%k:%M")}")
    @meeting.ends_at = @meeting.starts_at + current_user.preference.meetings_duration.minutes
    @meeting.host = current_user

    if @meeting.accept!
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

  def update
    @meeting = Meeting.find(params[:id])
    @meeting.cancel_reason = params[:meeting][:cancel_reason]

    if @meeting.cancel!
      flash[:notice] = "La cita ha sido cancelada con éxito."
    else
      flash[:error] = "La cita no ha sido cancelada."
    end

    redirect_back_or("/")
  end

  protected
  def valid_date?(date)
    unless Meeting.valid_date?(date)
      flash[:error] = "Fecha fuera de evento."
      redirect_back_or("/")
    end
  end

  def valid_host_and_guest?(host, guest)
    if host.id == guest.id
      flash[:error] = "No puede solicitarse una cita a si mismo."
      redirect_back_or("/")
    end
  end
end
