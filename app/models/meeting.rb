class Meeting < ActiveRecord::Base
  include AASM

  belongs_to :host, :class_name => 'User', :include => :profile
  belongs_to :guest, :class_name => 'User', :include => :profile

  validates_presence_of :host_id, :guest_id

  # This named_scope is for filter between national_buyer or international_buyer 
  named_scope :with_type, lambda {|type| {:from => "roles_users as ru, roles as r, meetings as m",
    :conditions => ["(m.guest_id = ru.user_id or m.host_id = ru.user_id) and ru.role_id = r.id and r.title = ?", type] } }
  named_scope :with_state, lambda{|state| {:conditions => ["state = ?", state]}}
  named_scope :in, lambda {|date| {:conditions => ["DATE(starts_at) = ?", date]}}

  def validate
    errors.add("host_id", "Usted debe ser un expositor.") unless self.host && self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador.") unless self.guest && (self.guest.is_buyer?)

    errors.add("max_meetings", "Ha superado tu número de citas máximo para este día.") if !Meeting.valid_meetings_number?(self.host, self.starts_at) && self.new_record?

    if new_record? && !Meeting.between(self.host, self.guest).new_record?
      errors.add("guest_id", "Ya tiene una cita con este comprador.") 
    end

    #Dentro de las jornadas del evento
    # errors.add("starts_at", "La cita debe estar dentro de las jornadas del evento.") unless Meeting.valid_event_date?(self.starts_at)
    #Dentro de la asistencia del guest
    unless (self.guest.assistance_day(self.starts_at.day).include?(self.starts_at.hour))
      errors.add("starts_at", "El comprador no asiste a esa hora al evento.") 
    end

    if new_record? && !Meeting.valid_date?(self.host, self.guest, self.starts_at, self.ends_at)
      errors.add("starts_at", "Compruebe que ni usted ni el comprador tengan una cita aceptada o pendiente durante el periodo seleccionado.") 
    end
  end

  #Le ponemos la fecha fin automáticamente
  def before_validation
    self.ends_at =(self.starts_at + self.host.preference.meetings_duration.minutes)
  end

  #AASM 
  aasm_column :state
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :accepted #En determinados casos se aceptará automáticamente
  aasm_state :canceled, :enter => Proc.new{ |m| MeetingMailer.send_later(:deliver_meeting_canceled, m) }
  

  aasm_event :accept do
    transitions :from => :pending, :to => :accepted
  end

  aasm_event :cancel do
    transitions :from => [:accepted, :pending], :to => :canceled
  end

  def name(user, always_busy = false)
    if always_busy
      "Ocupado"
    else
      if user.login == host.login 
        guest.profile.company_name
      elsif user.login == guest.login
        host.profile.company_name
      # else
      #   "Ocupado"
      end
    end     
  end

  # Return meeting between into host and guest or return new meeting
  def self.between(host, guest, return_new = true)
    host, guest = guest, host if host.is_buyer?

    if meeting = find(:first, :conditions => ["host_id = ? AND guest_id = ? AND state != ?", host, guest, "canceled"])
      return meeting
    end

    new
  end

  # Check that a +date+ belongs to defined event calendar 
  def self.valid_event_date?(date)
    date = Date.parse(date) unless [Date, DateTime, Time, ActiveSupport::TimeWithZone].include? date.class 
    
    if date < Event.start_day || date > Event.end_day
      return false
    end

    if date.respond_to?(:hour)
      if date.hour < PREFS[:event_day_start_at].to_i || date.hour > PREFS[:event_day_end_at].to_i
        return false
      end
    end

    true
  end

  def self.valid_date?(host, guest, starts, ends)
    waps = lambda do |user, starts, ends| 
      # starts += 1.seconds
      ends -= 1.seconds
      Meeting.find(:first, 
         :conditions => ["(host_id = ? OR guest_id = ?) AND 
          (starts_at BETWEEN ? AND ? OR ends_at BETWEEN ? AND ?) AND (state != 'canceled')", 
           user, user, starts, ends, starts + 1.second, ends])
    end
    
    return false if waps.call(host, starts, ends).present? || waps.call(guest, starts, ends).present?
    true
  end

  def self.valid_meetings_number?(user, date)
    user.meetings(date).length < user.preference.meetings_number
  end

  #Fecha de la cita formateada correctamente
  #m.date(:include_month => true, :include_week_day => false)
  def date(options = {})
    res = ""
    res += "#{I18n.localize(self.starts_at, :format => '%A %d')} de " if options[:include_week_day] != false
    res += "#{I18n.localize(self.starts_at, :format => '%B')} de " if options[:include_month] != false
    res += "#{self.starts_at.strftime("%H:%M")} a #{(self.starts_at + 15.minutes).strftime("%H:%M")}"
  end

  #Obtención del interlocutor de la quedada, insertamos mi usuario como parámetro de entrada
  def partner(me)
    if(self.host == me)
      self.guest
    elsif(self.guest == me)
      self.host
    end
  end

  #Duración de la cita
  def duration
    (self.ends_at - self.starts_at)/60
  end
end
