class MeetingObserver < ActiveRecord::Observer
  observe :meeting

  def after_create(record)
    if record.guest.is_national_buyer?  
      record.accept!
      MeetingMailer.send_later(:deliver_new_meeting, record) #Email nueva cita
    elsif record.guest.is_international_buyer?
      MeetingMailer.send_later(:deliver_alert_for_extenda, record) #Aviso a los usuarios extenda
    end
  end


end

