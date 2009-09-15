class Message < ActiveRecord::Base
  attr_accessor :receivers_string, :send_all, :send_exhibitors, :send_national_buyers, :send_international_buyers

  belongs_to :sender, :class_name => 'User'
  has_many :user_messages
  has_many :receivers, :class_name => 'User', :through => :user_messages

  validates_presence_of :sender, :message, :subject

  def validate
    errors.add(:sender_id, "Debe enviar el mensaje a al menos una persona") if self.receivers.blank?
  end

  def receiver(links = true)
    self.receivers.inject(""){|res, e| 
      unless e.is_extenda?
        if links
          res += "<a href='/perfiles/#{e.profile.id}' class='profile-link' id='#{e.profile.id}'>#{e.profile.company_name}</a>, "
        else
          res += "#{e.profile.company_name}, "
        end
      else
        res
      end
    }.gsub(/, $/,"")
  end

  # def send_all=(boolean)
  #   self.receivers = User.no_admins if boolean == "1"
  # end
  #
  def send_exhibitors=(boolean)
    self.receivers << User.exhibitors if boolean == "1"
  end

  def send_national_buyers=(boolean)
    self.receivers << User.national_buyers if boolean == "1"
  end

  def send_international_buyers=(boolean)
    self.receivers << User.international_buyers if boolean == "1"
  end

  def receivers_string=(string)
    string.split("; ").uniq.each do |company_name|
      profile = Profile.find_by_company_name(company_name)
      self.receivers << profile.user if profile
    end
  end

  


end
