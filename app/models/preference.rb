class Preference < ActiveRecord::Base

  has_many :users

  validates_presence_of :meetings_number, :meetings_duration, :event_start_day, :event_end_day, :event_day_start_at, :event_day_end_at
  validates_numericality_of :meetings_number, :meetings_duration

  def before_destroy
    self.users.each do |u|
      u.update_attributes(:preference_id => 1)
    end
  end
end
