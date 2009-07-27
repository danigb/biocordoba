class Message < ActiveRecord::Base
  attr_accessor :receivers_string

  belongs_to :sender, :class_name => 'User'
  has_many :user_messages
  has_many :receivers, :class_name => 'User', :through => :user_messages

  validates_presence_of :sender_id, :message

  def validate
    # errors.add(:sender_id, "No te puedes enviar el mensaje a ti mismo") if self.receivers.map(&:receiver_id).include?(sender_id)
  end

  def receiver
    self.receivers.inject(""){|res, e| res += "#{e.profile.company_name} " }
  end

  # named_scope :unread, :conditions => {:state => 'unread'}, :order => 'created_at desc'

  def receivers_string=(string)
    string.split(", ").each do |company_name|
      self.receivers << Profile.find_by_company_name(company_name).user 
    end
  end
end
