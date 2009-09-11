class MeetingsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_filter :login_required
  before_filter :access_control, :only => [:show, :update, :change_note]
  before_filter :show_meetings_remaining, :only => :new
  cache_sweeper :meeting_sweeper, :only => [:change_state, :create]

  def index
  end

  def show
    if @meeting.host == current_user
      @host = true
    elsif @meeting.guest == current_user
      @guest = true
    end
    @admin_extenda = current_user.is_admin_or_extenda?

    respond_to do |format|
      format.html{}
      format.js{
        render :layout => false
      }
    end
  end

  def new
    unless @loaded #FIX que impide que se cargue de nuevo si lo hemos cargado en el before filter
      @host = User.find_by_login(params[:host_id])
      @guest = User.find_by_login(params[:guest_id])

      !valid_host_and_guest?(@host, @guest) || !valid_event_date?(@date) || !valid_guest?(@guest)
      @date = params[:date].present? ? Date.parse(params[:date]) : current_user.preference.event_start_day
    end
  end

  def create 
    @meeting = Meeting.new(params[:meeting])
    @meeting.starts_at = Time.parse("#{params[:date]} #{@meeting.starts_at.strftime("%k:%M")}")
    @meeting.host = current_user

    if @meeting.save
      flash[:notice] = @meeting.guest.is_international_buyer? ? "La cita está pendiente de aceptación" : "La cita ha sido creada."
      redirect_to root_path
    else
      if @meeting.errors[:starts_at]
        flash.now[:error] = "No se ha guardado la cita. #{@meeting.errors[:starts_at]}."
      elsif @meeting.errors[:max_meetings]
        flash.now[:error] = "No se ha guardado la cita. Ha superado el número máximo de citas."
      else
        flash.now[:error] = "No se ha guardado la cita. Ya tiene un cita con este comprador."
      end

      # Reloading vars
      params[:host_id] = current_user.login
      params[:guest_id] = @meeting.guest.login
      new

      render :action => 'new'
    end
  end

  #Se está usando para cancelar citas
  def update
    @meeting.cancel_reason = params[:meeting][:cancel_reason] if params[:meeting]
    if @meeting.cancel!
      flash[:notice] = "La cita ha sido cancelada con éxito."
    else
      flash[:error] = "La cita no ha sido cancelada."
    end

    redirect_back_or("/")
  end

  def change_note
    if(@meeting.update_attributes(params[:meeting]))
      flash[:notice] = "Nota actualizada"
      redirect_to root_path
    end
  end

  def type
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    !valid_event_date?(@date)

    @name = params[:type].chop # exhibitors -> exhibitor
    meetings = @name == "exhibitor" ? Meeting.in(@date).with_state("accepted") : Meeting.in(@date).with_type(@name).with_state("accepted")
    @guest = true unless @name == "exhibitor"
    @meetings_by_host = meetings.group_by{|m| @guest ? m.guest : m.host }
  end

  def for_user
    if @user = User.find_by_login(params[:id]) 
      @date = Time.parse("#{CONFIG[:admin][:preferences][:event_start_day]} #{CONFIG[:admin][:preferences][:event_day_start_at]}")
      @days = 3
      @meetings = @user.meetings(@date, @days)
    else
      redirect_back_or("/") and return
    end
  end

  def to_confirm
    @meetings = Meeting.with_type("international_buyer").with_state("pending")
  end

  def change_state
    meeting = Meeting.find(params[:id])

    if %w(accept cancel).include?(params[:state])
      meeting.send("#{params[:state]}!")
      if params[:state] == "accept" 
        flash[:notice] = "La cita ha sido aceptada."
        #Enviamos mail de cita aceptada
        MeetingMailer.send_later(:deliver_meeting_accepted, meeting)
      else
        #El email lo enviamos desde el modelo, ya que también cancelamos usando el método update
        flash[:notice] = "La cita ha sido rechazada/cancelada."
      end
    end

    redirect_to :back
  end

  def print
    @date = Event.start_day_and_hour
    @days = Event.duration
    @role = current_user.is_exhibitor? ? "host" : "guest"
    render :layout => "print"
  end


  def print_admin_extenda
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.parse(CONFIG[:admin][:preferences][:event_start_day])
    !valid_event_date?(@date)

    @name = params[:type].chop # exhibitors -> exhibitor
    meetings = @name == "exhibitor" ? Meeting.in(@date).with_state("accepted") : Meeting.in(@date).with_type(@name).with_state("accepted")
    @guest = true unless @name == "exhibitor"
    @meetings_by_host = meetings.group_by{|m| @guest ? m.guest : m.host }
    
    @days = params[:date].present? ? 1 : Event.duration 

    render :layout => "print"

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

  #Comprueba que los usuarios existen y que no son el mismo
  def valid_host_and_guest?(host, guest)
    if !host || !guest || host.id == guest.id
      flash[:error] = "Los usuarios de la cita no son válidos."
      redirect_back_or("/") 
      return false
    end

    unless host.is_exhibitor?
      flash[:error] = "No puede solicitar una cita."
      redirect_back_or("/") 
      return false
    end
  end


  private

  def access_control
    @meeting = Meeting.find(params[:id])
    unless current_user == @meeting.host || current_user == @meeting.guest || current_user.is_admin_or_extenda?
      flash[:error] = "No puede acceder a ver esa cita"
      redirect_to root_path
    end
  end

  def show_meetings_remaining
    @host = User.find_by_login(params[:host_id])
    @guest = User.find_by_login(params[:guest_id])

    !valid_host_and_guest?(@host, @guest) || !valid_event_date?(@date) || !valid_guest?(@guest)
    @date = params[:date].present? ? Date.parse(params[:date]) : current_user.preference.event_start_day
    @meeting = Meeting.new
    @remaining = current_user.meetings_remaining(@date)
    @loaded = true

    if @remaining > 0
      flash.now[:notice] = "Puede hacer #{pluralize(@remaining, 'cita', 'citas')} más este día"
    else
      flash.now[:error] = "Ha superado el número máximo de citas para este día"
    end
  end
end
