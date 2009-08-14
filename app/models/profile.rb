class Profile < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :sectors
  belongs_to :province
  belongs_to :town


  validates_presence_of :company_name
  validates_numericality_of :phone, :fax, :allow_blank => true
  validates_url_format_of :website, :message => "Formato de página web incorrecto", :allow_blank => true

  def validate
    errors.add(:sectors, "Debe seleccionar al menos un sector") if self.sectors.blank? && self.user && !self.user.is_admin_or_extenda?
  end

end
