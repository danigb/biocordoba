class Country < ActiveRecord::Base
  validates_presence_of :name, :code

  default_scope :order => 'name'
end
