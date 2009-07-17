class Sector < ActiveRecord::Base
  has_many :profiles 
  validates_presence_of :name
end
