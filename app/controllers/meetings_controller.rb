class MeetingsController < ApplicationController
  before_filter :login_required
  
  def index
    @international_buyers = Role.find_by_title('international_buyer').users
    @national_buyers = Role.find_by_title('national_buyer').users
  end

  def new
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    @host = User.find_by_login(params[:host_id])
    @guest = User.find_by_login(params[:guest_id])

    !valid_host_and_guest?(@host, @guest) || !valid_event_date?(@date) || !valid_guest?(@guest)
    @meeting = Meeting.between(@host, @guest)
  end

  def create 
    @meeting = Meeting.new(params[:meeting])
    @meeting.starts_at = Time.parse("#{params[:date]} #{@meeting.starts_at.strftime("%k:%M")}")
    @meeting.ends_at = @meeting.starts_at + current_user.preference.meetings_duration.minutes
    @meeting.host = current_user

    if @meeting.save
      flash[:notice] = "La cita se ha guardado con éxito."
      redirect_to root_path
    else
      if @meeting.errors[:starts_at]
        flash.now[:error] = "No se ha guardado la cita. La fecha ya está reservada."
      else
        flash.now[:error] = "No se ha guardado la cita. Ya tienes un cita con este comprador."
      end

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

  def type
    @name = params[:type].chop # exhibitors -> exhibitor
    meetings = @name == "exhibitor" ? Meeting.all : Meeting.for(@name)
    @meetings_by_day = meetings.group_by{|m| I18n.localize(m.starts_at, :format => '%A %d')}
  end

  def for_user
    begin
      @user = User.find_by_login(params[:id]) 
    rescue 
      redirect_back_or("/") and return
    end

    @date = Time.parse("#{CONFIG[:admin][:preferences][:event_start_day]} #{CONFIG[:admin][:preferences][:event_day_start_at]}")
    @days = 3
    @meetings = @user.meetings(@date, @days)
  end

  protected
  def valid_guest?(guest)
    unless guest.is_national_buyer? || guest.is_international_buyer?
      flash[:error] = "Empresa no valida."
      redirect_back_or("/") 
      return false
    end  
  end

  def valid_event_date?(date)
    unless Meeting.valid_event_date?(date)
      flash[:error] = "Fecha fuera de evento."
      redirect_back_or("/") 
      return false
    end
  end

  def valid_host_and_guest?(host, guest)
    if host.id == guest.id
      flash[:error] = "No puede solicitarse una cita a si mismo."
      redirect_back_or("/") 
      return false
    end
  end
end
