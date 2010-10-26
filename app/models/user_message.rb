class UserMessage < ActiveRecord::Base
  include AASM

  # validates_uniqueness_of :receiver_id, :scope => :message_id
  validates_presence_of :receiver_id, :message_id

  belongs_to :receiver, :class_name => 'User'
  belongs_to :message
  #Indirect receiver es usado por los usuarios extenda para ver a quién iba dirigido el mensaje
  belongs_to :indirect_receiver, :class_name => 'User'
  
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
    #Si el receptor es un usuario internacional debemos:
    #- Enviar el mensaje a los usuarios extenda
    #Usamos indirect_receiver_id para indicar a que usuario referenciamos indirectamente con el mensaje, 
    #es decir a quién va dirigido el mensaje aparte de a nosotros como extenda
    if self.receiver.is_international_buyer?
      User.extendas.each do |e|
        e.user_messages.create(:message => self.message, :indirect_receiver => self.receiver)
      end
      #Notificarles, sólo si están activos
      UserMailer.send_later(:deliver_new_message_to_international_user, self.receiver, self.message) if self.receiver.enabled?

      #Borramos el mensaje que iba dirigido al comprador internacional
      # self.destroy TODO, no lo borramos, para simplificar la muestra
    else
      UserMailer.send_later(:deliver_new_message_received, self.receiver, self.message) if self.receiver.enabled?
    end
  end

end

# == Schema Information
#
# Table name: user_messages
#
#  id                   :integer(4)      not null, primary key
#  receiver_id          :integer(4)      not null
#  message_id           :integer(4)      not null
#  state                :string(255)
#  indirect_receiver_id :integer(4)
#

