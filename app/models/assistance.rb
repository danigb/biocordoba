class Assistance < ActiveRecord::Base
  belongs_to :preference
  after_create :default_assistances

  validates_presence_of :day, :arrive, :leave, :preference_id

  def validate
    if arrive.nil? || leave.nil? || arrive.hour >= leave.hour
      errors.add(:arrive, "La hora de salida debe ser mayor que la hora de llegada")
    end

    if self.day > self.preference.event_end_day || self.day < self.preference.event_start_day
      errors.add(:leave, "El día está fuera del evento")
    end
      
    if self.leave.hour > self.preference.event_day_end_at.hour
      errors.add(:leave, "La hora está fuera del horario del evento")
    end

    if self.arrive.hour < self.preference.event_day_start_at.hour
      errors.add(:arrive, "La hora está fuera del horario del evento")
    end
    #Hay que comprobar que no se pisen
    # if self.day > self.preference.event_end_day || self.day < self.preference.event_start_day
    #   errors.add(:leave, "El día está fuera del evento")
    # end

  end

  def default_assistances
    %w(22 23 24).each do |day|
      Assistance.create(:day => Date.parse("#{day}-09-2009"), :preference_id => self.id, :arrive => Time.parse("10:00"), :leave => Time.parse("19:00"))
    end
  end
end
