class MeetingsController < ApplicationController
  before_filter :login_required
  before_filter :access_control, :only => [:show, :update, :change_note]
  before_filter :show_meetings_remaining, :only => :new
  include ActionView::Helpers::TextHelper

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
      @meeting = Meeting.between(@host, @guest)
    end
  end

  def create 
    @meeting = Meeting.new(params[:meeting])
    @meeting.starts_at = Time.parse("#{params[:date]} #{@meeting.starts_at.strftime("%k:%M")}")
    @meeting.host = current_user

    if @meeting.save
      flash[:notice] = "La cita se ha guardado con éxito."
      redirect_to root_path
    else
      if @meeting.errors[:starts_at]
        flash.now[:error] = "No se ha guardado la cita. #{@meeting.errors[:starts_at]}."
      elsif @meeting.errors[:max_meetings]
        flash.now[:error] = "No se ha guardado la cita. Has superado el número máximo de citas."
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

  private

  def access_control
    @meeting = Meeting.find(params[:id])
    unless current_user == @meeting.host || current_user == @meeting.guest || current_user.is_admin_or_extenda?
      flash[:error] = "No puedes acceder a ver esa cita"
      redirect_to root_path
    end
  end

  def show_meetings_remaining
    @host = User.find_by_login(params[:host_id])
    @guest = User.find_by_login(params[:guest_id])

    !valid_host_and_guest?(@host, @guest) || !valid_event_date?(@date) || !valid_guest?(@guest)
    @date = params[:date].present? ? Date.parse(params[:date]) : current_user.preference.event_start_day
    @meeting = Meeting.between(@host, @guest)
    @remaining = current_user.meetings_remaining(@date)
    @loaded = true

    if @meeting.new_record?
      if @remaining > 0
        flash[:notice] = "Puedes hacer #{pluralize(@remaining, 'cita', 'citas')} más este día"
      else
        flash[:error] = "Has superado el número máximo de citas para este día"
      end
    else
      flash[:notice] = "Ya tienes una cita con este comprador, ¿la quieres cancelar?"
    end
  end
end
