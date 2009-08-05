class Meeting < ActiveRecord::Base
  include AASM

  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'

  validates_presence_of :host_id, :guest_id

  # This named_scope is for filter between national_buyer or international_buyer 
  named_scope :with_type, lambda {|type| {:from => "roles_users as ru, roles as r, meetings as m",
    :conditions => ["(m.guest_id = ru.user_id or m.host_id = ru.user_id) and ru.role_id = r.id and r.title = ?", type] } }
  named_scope :with_state, lambda{|state| {:conditions => ["state = ?", state]}}
  named_scope :in, lambda {|date| {:conditions => ["DATE(starts_at) = ?", date]}}

  def validate
    errors.add("host_id", "Usted debe ser un expositor") unless self.host && self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador") unless self.guest && (self.guest.is_buyer?)

    if new_record? && !Meeting.between(self.host, self.guest).new_record?
      errors.add("guest_id", "Ya tienes una cita con este comprador") 
    end

    unless Meeting.valid_event_date?(self.starts_at)
      errors.add("starts_at", "Fecha fuera de evento")
    end

    if new_record? && !Meeting.valid_date?(self.host, self.guest, self.starts_at)
      errors.add("starts_at", "Fecha ya reservada") 
    end
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

  def name(user, me = true)
    if me
      user.login == host.login ? host.profile.company_name : guest.profile.company_name
    else
      if user.login == host.login 
        guest.profile.company_name
      elsif user.login == guest.login
        host.profile.company_name
      else
        "Ocupado"
      end
    end     
  end

  # Return meeting between into host and guest or return new meeting
  def self.between(host, guest, return_new = true)
    host, guest = guest, host if host.is_buyer?

    if meeting = find_by_host_id_and_guest_id_and_state(host, guest, "accepted")
      return meeting
    end

    new
  end

  # Check that a +date+ belongs to defined event calendar 
  def self.valid_event_date?(date)
    date = Date.parse(date) unless [Date, DateTime, Time, ActiveSupport::TimeWithZone].include? date.class 
    
    if date < Date.parse(PREFS[:event_start_day]) || date > Date.parse(PREFS[:event_end_day])
      return false
    end

    if date.respond_to?(:hour)
      if date.hour < PREFS[:event_day_start_at].to_i || date.hour > PREFS[:event_day_end_at].to_i
        return false
      end
    end

    true
  end

  def self.valid_date?(host, guest, date)
    waps = lambda do |user, date| 
      Meeting.find(:first, 
        :conditions => ["(host_id = ? OR guest_id = ?) AND DATE(starts_at) = ?", user, user, date.strftime("%Y-%m-%d")])
    end
    
    return false if waps.call(host, date).present? || waps.call(guest, date)
    true
  end

end
