class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :sector, :counter_cache => true
  belongs_to :province
  belongs_to :town


  validates_presence_of :company_name, :sector_id
  validates_numericality_of :phone, :fax, :allow_blank => true
  validates_url_format_of :website, :message => "Formato de página web incorrecto", :allow_blank => true

end
