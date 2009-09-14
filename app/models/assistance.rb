class Assistance < ActiveRecord::Base
  belongs_to :preference

  validates_presence_of :day, :arrive, :leave, :preference_id

  def validate
    if arrive.nil? || leave.nil? || arrive.hour > leave.hour
      errors.add(:arrive, "La hora de salida debe ser mayor que la hora de llegada")
    end
  end
end
