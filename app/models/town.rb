class Town < ActiveRecord::Base
  belongs_to :province
  validates_presence_of :name, :province_id
end
