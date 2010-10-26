class Preference < ActiveRecord::Base

  after_create :default_assistances

  has_many :users
  has_many :assistances, :order => :day

  validates_presence_of :meetings_number, :meetings_duration, :event_start_day, :event_end_day, :event_day_start_at, :event_day_end_at
  validates_numericality_of :meetings_number, :meetings_duration

  #Tres configuraciones por defecto
  named_scope :general_for_exhibitor, :conditions => {:id => 1}
  named_scope :general_for_national_buyer, :conditions => {:id => 2}
  named_scope :general_for_international_buyer, :conditions => {:id => 3}

  def before_destroy
    self.users.each do |u|
      if u.is_exhibitor?
        id = 1
      elsif u.is_national_buyer?
        id = 2
      elsif u.is_international_buyer?
        id = 3
      end

      u.update_attributes(:preference_id => id)
    end
  end

  def default_assistances
    %w(22 23 24).each do |day|
      Assistance.create(:day => Date.parse("#{day}-09-2009"), :preference_id => self.id, :arrive => Time.parse("10:00"), :leave => Time.parse("19:00"))
    end
  end
end

# == Schema Information
#
# Table name: preferences
#
#  id                 :integer(4)      not null, primary key
#  meetings_number    :integer(4)
#  meetings_duration  :integer(4)
#  event_start_day    :date
#  event_end_day      :date
#  event_day_start_at :time
#  event_day_end_at   :time
#  created_at         :datetime
#  updated_at         :datetime
#

