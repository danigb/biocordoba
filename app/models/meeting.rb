class Meeting < ActiveRecord::Base
  belongs_to :host, :class_name => 'User'
  belongs_to :guest, :class_name => 'User'
end
