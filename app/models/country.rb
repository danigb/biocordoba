class Country < ActiveRecord::Base
  validates_presence_of :name, :code

  default_scope :order => 'name'

  named_scope :with_profiles, :conditions => ["profiles_count > 0"]
end

# == Schema Information
#
# Table name: countries
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  code           :string(255)
#  profiles_count :integer(4)      default(0)
#

