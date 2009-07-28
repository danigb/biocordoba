class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :sector, :counter_cache => true
  validates_presence_of :company_name, :address, :sector_id
  validates_uniqueness_of :company_name
end
