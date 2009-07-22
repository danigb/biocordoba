class Meeting < ActiveRecord::Base
  include AASM

  after_create :accept_state, :if => Proc.new { |m| m.guest.is_national_buyer? } 

  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'

  validates_presence_of :host_id, :guest_id
  validates_uniqueness_of :host_id, :scope => [:guest_id, :state], :message => "Ya tienes una cita con este comprador."

  def validate
    errors.add("host_id", "Usted debe ser un expositor") unless self.host && self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador") unless self.guest && (self.guest.is_national_buyer? || self.guest.is_international_buyer?)
  end

  #AASM 
  aasm_column :state
  aasm_initial_state :pending

  aasm_state :pending 
  aasm_state :acepted #En determinados casos se aceptará automáticamente
  aasm_state :canceled

  aasm_event :acept do
    transitions :from => :pending, :to => :acepted
  end

  aasm_event :cancel do
    transitions :from => [:acepted, :pending], :to => :canceled
  end

  private
  
    #El meting se acepta automáticamente si el invitado es un comprador nacional
    def accept_state
      self.acept!
    end

end
