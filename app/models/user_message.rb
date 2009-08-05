class UserMessage < ActiveRecord::Base
  include AASM

  validates_uniqueness_of :receiver_id, :scope => :message_id
  validates_presence_of :receiver_id, :message_id

  belongs_to :receiver, :class_name => 'User'
  belongs_to :message
  
  aasm_column :state
  aasm_initial_state :unread

  aasm_state :unread
  aasm_state :read
  aasm_state :deleted

  aasm_event :mark_as_read do
    transitions :from => :unread, :to => :read
  end

  aasm_event :delete_message do
    transitions :from => [:unread, :read], :to => :deleted
  end

  fires :new_received_message, :on => :create,
                     :actor => :receiver,
                     :subject => :message,
                     :secondary_subject => :sender_profile

  def sender_profile
    self.message.sender.profile
  end


  #Mandamos un email al que ha recibido el mensaje
  def after_create
    UserMailer.send_later(:deliver_new_message_received, self.receiver, self.message)
  end

end
