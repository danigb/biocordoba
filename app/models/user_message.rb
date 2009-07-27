class UserMessage < ActiveRecord::Base
  include AASM

  belongs_to :receiver, :class_name => 'User'
  belongs_to :message
  
  aasm_column :state
  aasm_initial_state :unread

  aasm_state :unread
  aasm_state :read

  aasm_event :mark_as_read do
    transitions :from => :unread, :to => :read
  end

end
