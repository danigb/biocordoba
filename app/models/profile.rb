class Profile < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :sectors
  belongs_to :province
  belongs_to :town
  belongs_to :country


  validates_presence_of :company_name
  validates_numericality_of :zip_code, :allow_blank => true
  # validates_url_format_of :website, :message => "Formato de página web incorrecto", :allow_blank => true

  def validate
    errors.add(:sectors, "Debe seleccionar al menos un sector") if self.sectors.blank? 
  end

  #User to xml parse
  def province_name
     self.province.name if self.province
  end

  def town_name
    self.town.name if self.town
  end

  def country_id
     self[:country_id] || 23
  end

  def sectors_string
    self.sectors.inject(""){|sum, e| sum += "#{e.name}, "}.gsub(/, $/, ".")
  end
end
