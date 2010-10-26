class Province < ActiveRecord::Base
  has_many :towns
  validates_presence_of :name
end

# == Schema Information
#
# Table name: provinces
#
#  id   :integer(4)      primary key
#  name :string(255)
#

