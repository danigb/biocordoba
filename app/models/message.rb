class Message < ActiveRecord::Base
  include AASM

  belongs_to :sender, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'

  validates_presence_of :sender_id, :receiver_id, :message

  named_scope :unread, :conditions => {:state => 'unread'}, :order => 'created_at desc'

  aasm_column :state
  aasm_initial_state :unread

  aasm_state :unread
  aasm_state :read

  aasm_event :mark_as_read do
    transitions :from => 'unread', :to => 'read'
  end

end
