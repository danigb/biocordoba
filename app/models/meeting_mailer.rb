class MeetingMailer < ActionMailer::Base
  layout 'email'
  def alert_for_extenda(meeting)
    setup_email
    @recipients = User.type("extenda").map(&:email)
    @subject += "Nueva cita pendiente de aceptar"  
    @body = {:meeting => meeting}
  end   

  def meeting_canceled(meeting)
    setup_email
    @recipients = []
    @recipients << meeting.host.email if meeting.host.email
    @recipients << meeting.guest.email if meeting.guest.email
    @subject += "Cita cancelada"
    @body = {:meeting => meeting}
  end

  #Cita aceptada por extenda
  def meeting_accepted(meeting)
    setup_email
    @recipients = meeting.host.email
    @subject += "Cita aceptada"
    @body = {:meeting => meeting}
  end

  def new_meeting(meeting)
    setup_email
    @recipients = meeting.guest.email
    @subject += "Nueva cita"
    @body = {:meeting => meeting}
  end

  def summary(user, date = Time.now.to_date)
    setup_email
    @recipients = user.email
    @subject += "Resumen de citas para el día de hoy"
    @body = {:meetings => user.meetings(date, 1), :user => user, :date => date.localize}
  end

  def setup_email
    @from = "BIOCórdoba. Organic food trade show <info@agendabiocordoba.com>"
    @subject = "[BIOCórdoba] "
    @sent_on = Time.now 
    @content_type = "text/html"
    # @bcc = ["info@beecoder.com"]
  end
end
