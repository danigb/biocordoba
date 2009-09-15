class MeetingObserver < ActiveRecord::Observer
  observe :meeting

  def after_create(record)
    if record.guest.is_national_buyer?  
      record.accept!
      #Email nueva cita
      MeetingMailer.send_later(:deliver_new_meeting, record) if record.guest.email.present?
    elsif record.guest.is_international_buyer?
      #Aviso a los usuarios extenda
      MeetingMailer.send_later(:deliver_alert_for_extenda, record) if record.guest.email 
    end
  end


end

