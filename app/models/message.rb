class Message < ActiveRecord::Base
  attr_accessor :receivers_string, :send_all

  belongs_to :sender, :class_name => 'User'
  has_many :user_messages
  has_many :receivers, :class_name => 'User', :through => :user_messages

  validates_presence_of :sender, :message, :subject

  def validate
    errors.add(:sender_id, "Debes introducir un receptor válido") if self.receivers.blank?
  end

  def receiver
    self.receivers.inject(""){|res, e| res += "#{e.profile.company_name}, " }.gsub(/, $/,"")
  end

  def send_all=(boolean)
    self.receivers = boolean == "1" ? User.no_admins : []
  end

  def receivers_string=(string)
    string.split(", ").uniq.each do |company_name|
      profile = Profile.find_by_company_name(company_name)
      if profile
        self.receivers << profile.user 
      end
    end
  end


end
