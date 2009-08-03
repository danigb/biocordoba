class Meeting < ActiveRecord::Base
  include AASM

  after_create :accept_state, :if => Proc.new { |m| m.guest.is_national_buyer? } 

  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'

  validates_presence_of :host_id, :guest_id

  # This named_scope is for filter between national_buyer or international_buyer 
  named_scope :type, lambda {|type| {:from => "roles_users as ru, roles as r, meetings as m",
    :conditions => ["m.guest_id = ru.user_id and ru.role_id = r.id and r.title = ?", type] } }
  named_scope :with_state, lambda{|state| {:conditions => ["state = ?", state]}}

  def validate
    errors.add("host_id", "Usted debe ser un expositor") unless self.host && self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador") unless self.guest && (self.guest.is_national_buyer? || self.guest.is_international_buyer?)

    if new_record? && Meeting.find_by_host_id_and_guest_id_and_state(self.host, self.guest, "accepted")
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
  aasm_state :canceled

  aasm_event :accept do
    transitions :from => :pending, :to => :accepted
  end

  aasm_event :cancel do
    transitions :from => [:accepted, :pending], :to => :canceled
  end

  def name(user)
    self.host_id == user.id ? guest.login : host.login 
  end

  # Return meeting between into host and guest or return new meeting
  def self.between(host, guest)
    if meeting = find_by_host_id_and_guest_id_and_state(host, guest, "accepted")
      return meeting
    end

    new
  end

  # Check that a +date+ belongs to defined event calendar 
  def self.valid_event_date?(date)
    date = Date.parse(date) unless date.class == Date || date.class == ActiveSupport::TimeWithZone
    
    if date < Date.parse(PREFS[:event_start_day]) || date > Date.parse(PREFS[:event_end_day])
      return false
    end

    true
  end

  def self.valid_date?(host, guest, date)
    waps = lambda do |user, date| 
      Meeting.find(:first, 
        :conditions => ["(host_id = ? OR guest_id = ?) AND starts_at <= ? AND ends_at >= ?", user, user, date, date])
    end
    
    return false if waps.call(host, date).present? || waps.call(guest, date)
    true
  end

  private
  
    # El meeting se acepta automáticamente si el invitado es un comprador nacional
    def accept_state
      self.accept!
    end
end
