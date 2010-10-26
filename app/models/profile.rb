class Profile < ActiveRecord::Base

  belongs_to :user
  has_and_belongs_to_many :sectors
  belongs_to :province
  belongs_to :town
  belongs_to :country, :counter_cache => true


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
    self.sectors.inject(""){|sum, e| sum += "#{e.name.capitalize}, "}.gsub(/, $/, ".")
  end

  def website
    w = read_attribute(:website)
    if w && w.match("^www")
      "http://#{w}"
    else
      w
    end
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id                 :integer(4)      not null, primary key
#  company_name       :string(255)
#  address            :string(255)
#  zip_code           :integer(4)
#  province_id        :integer(4)
#  products           :string(255)
#  packages           :string(255)
#  commercial_profile :string(255)
#  user_id            :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  town_id            :integer(4)
#  phone              :integer(4)
#  fax                :integer(4)
#  website            :string(255)
#  stand              :string(255)
#  country_id         :integer(4)      default(23)
#  languages          :string(255)
#  contact_person     :string(255)
#  mobile_phone       :string(255)
#

