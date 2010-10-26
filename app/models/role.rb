class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :order => 'login', :include => :profile, :conditions => ["users.state = 'enabled'"], :order => 'profiles.company_name'

  validates_presence_of :title
  validates_uniqueness_of :title

  named_scope :public_roles, :conditions => ["title != 'admin' && title != 'extenda'"]
end

# == Schema Information
#
# Table name: roles
#
#  id    :integer(4)      not null, primary key
#  title :string(255)
#

