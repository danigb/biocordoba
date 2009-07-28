class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :sector, :counter_cache => true
  validates_presence_of :company_name, :sector_id

end
