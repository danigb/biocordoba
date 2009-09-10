#Clase que se encarga de representar el objeto evento
class Event
  #Fecha inicio del evento
  def self.start_day
    Date.parse(CONFIG[:admin][:preferences][:event_start_day])
  end

  #Hora inicio evento
  def self.day_start_hour
    Date.parse(CONFIG[:admin][:preferences][:event_day_start_at])
  end

  #Hora inicio evento
  def self.day_end_hour
    Date.parse(CONFIG[:admin][:preferences][:event_day_end_at])
  end

  #Hora y fecha inicio del evento
  def self.start_day_and_hour
    Time.parse("#{CONFIG[:admin][:preferences][:event_start_day]} #{CONFIG[:admin][:preferences][:event_day_start_at]}")
  end

  #Hora y fecha fin del evento
  def self.end_day_and_hour
    Time.parse("#{CONFIG[:admin][:preferences][:event_end_day]} #{CONFIG[:admin][:preferences][:event_day_end_at]}")
  end
  #Fecha fin evento
  #
  def self.end_day
    Date.parse(CONFIG[:admin][:preferences][:event_end_day])
  end

  #Número días duración evento
  def self.duration
    end_day.day - start_day.day + 1
  end

  #Array con las fechas que comprende el evento
  def self.days
    res = []
    Event.duration.times do |i|
      res << Event.start_day + i
    end
    res
  end
end

