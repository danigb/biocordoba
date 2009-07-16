class Meeting < ActiveRecord::Base
  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'

  validates_presence_of :host_id, :guest_id
  validates_uniqueness_of :host_id, :scope => [:guest_id, :state]

  def validate
    errors.add("host_id", "Usted debe ser un expositor") unless self.host.is_exhibitor?
    errors.add("guest_id", "Debe invitar a un comprador") unless self.guest.is_buyer?
  end
end
