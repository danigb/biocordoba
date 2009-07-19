class Province < ActiveRecord::Base
  has_many :towns
  validates_presence_of :name
end
