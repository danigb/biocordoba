class Message < ActiveRecord::Base
  attr_accessor :receivers_string

  belongs_to :sender, :class_name => 'User'
  has_many :user_messages
  has_many :receivers, :class_name => 'User', :through => :user_messages

  validates_presence_of :sender_id, :message, :subject

  def validate
    errors.add(:sender_id, "Debes introducir un receptor válido") if self.receivers.blank?
  end

  def receiver
    self.receivers.inject(""){|res, e| res += "#{e.profile.company_name}, " }.gsub(/, $/,"")

  end

  # named_scope :unread, :conditions => {:state => 'unread'}, :order => 'created_at desc'

  def receivers_string=(string)
    string.split(", ").uniq.each do |company_name|
      profile = Profile.find_by_company_name(company_name)
      if profile
        self.receivers << profile.user 
      end
    end
  end

end
