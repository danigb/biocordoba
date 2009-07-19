class Preference < ActiveRecord::Base

  validates_presence_of :meetings_number, :meetings_duration, :event_start_day, :event_end_day, :event_day_start_at, :event_day_end_at
end
