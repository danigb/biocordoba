class Town < ActiveRecord::Base
  belongs_to :province
  validates_presence_of :name, :province_id
end

# == Schema Information
#
# Table name: towns
#
#  id          :integer(4)      primary key
#  name        :string(255)
#  province_id :integer(4)
#

