class Meeting < ActiveRecord::Base
  include AASM

  # after_create :accept_state, :if => Proc.new { |m| m.guest.is_national_buyer? } 

  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'

  validates_presence_of :host_id, :guest_id
  # validates_uniqueness_of :host_id, :scope => [:guest_id, :state], :message => "Ya tienes una cita con este comprador."

  def validate
    errors.add("host_id", "Usted debe ser un expositor") unless self.host && self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador") unless self.guest && (self.guest.is_national_buyer? || self.guest.is_international_buyer?)

    if new_record? && Meeting.find_by_host_id_and_guest_id_and_state(self.host, self.guest, "accepted")
      errors.add("guest_id", "Ya tienes una cita con este comprador") 
    end

    unless Meeting.valid_date?(self.starts_at)
      errors.add("start_at", "Fecha fuera de evento")
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

  def self.valid_date?(date)
    date = Date.parse(date) unless date.class == Date || date.class == ActiveSupport::TimeWithZone
    preferences = CONFIG[:admin][:preferences]
    if date < Date.parse(preferences[:event_start_day]) || date > Date.parse(preferences[:event_end_day])
      return false
    end

    true
  end

  private
  
    # El meeting se acepta automáticamente si el invitado es un comprador nacional
    def accept_state
      self.accept!
    end
end
