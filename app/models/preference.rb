class Preference < ActiveRecord::Base

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

  # def event_start_day
  #   self[:event_start_day] || Event.start_day
  # end

  # def event_end_day
  #   self[:event_end_day] || Event.end_day
  # end

  # %w(22 23 24).each do |n|
  #   define_method "day_#{n}_arrival" do
  #     self["day_#{n}_arrival"] || Event.start_day_and_hour
  #   end

  #   define_method "day_#{n}_leave" do
  #     self["day_#{n}_leave"] || Event.end_day_and_hour
  #   end
  # end
end
