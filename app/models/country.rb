class Country < ActiveRecord::Base
  validates_presence_of :name, :code

  default_scope :order => 'name'

  named_scope :with_profiles, :conditions => ["profiles_count > 0"]
end
