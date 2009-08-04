class MeetingMailer < ActionMailer::Base
  def alert_for_extenda(meeting)
    recipients User.type("extenda").map(&:email)
    from "Andalucía Sabor International Fine Food Exhibition <andaluciasabor@andaluciasabor.es>"  
    subject "[Andalucía Sabor] Nueva cita pendiente de aceptar"  
    sent_on Time.now 
    body( {:meeting => meeting})  
  end   
end
