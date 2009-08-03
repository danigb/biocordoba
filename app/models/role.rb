class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :order => 'login'

  validates_presence_of :title
  validates_uniqueness_of :title

  named_scope :public_roles, :conditions => ["title != 'admin' && title != 'extenda'"]
end
