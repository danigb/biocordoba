class MeetingsController < ApplicationController
  before_filter :login_required
  
  def index
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
        flash.now[:error] = "No se ha guardado la cita. La fecha ya está reservada o está fuera del evento."
      else
        flash.now[:error] = "No se ha guardado la cita. Ya tienes un cita con este comprador."
      end

      # Reloading vars
      params[:host_id] = current_user.login
      params[:guest_id] = @meeting.guest.login
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
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    !valid_event_date?(@date)

    @name = params[:type].chop # exhibitors -> exhibitor
    meetings = @name == "exhibitor" ? Meeting.in(@date) : Meeting.in(@date).type(@name)
    @guest = true unless @name == "exhibitor"
    @meetings_by_host = meetings.group_by{|m| @guest ? m.guest : m.host }
  end

  def for_user
    begin
      @user = User.find_by_login(params[:id]) 
    rescue ActiveRecord::RecordNotFound
      redirect_back_or("/") and return
    end

    @date = Time.parse("#{CONFIG[:admin][:preferences][:event_start_day]} #{CONFIG[:admin][:preferences][:event_day_start_at]}")
    @days = 3
    @meetings = @user.meetings(@date, @days)
  end

  def to_confirm
    @meetings = Meeting.type("international_buyer").with_state("pending")
  end

  def change_state
    meeting = Meeting.find(params[:id])
    if meeting.pending? && %w(accepted canceled).include?(params[:state])
      meeting.send("#{params[:state][0..-3]}!")
      
      flash[:notice] = params[:state] == "accepted" ? "La cita ha sido aceptada." : "La cita ha sido rechazada."
    end

    redirect_to meetings_to_confirm_path
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

    unless host.is_exhibitor?
      flash[:error] = "No puede solicitar una cita."
      redirect_back_or("/") 
      return false
    end
  end
end
