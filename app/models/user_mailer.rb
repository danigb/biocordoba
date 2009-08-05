class UserMailer < ActionMailer::Base
  layout 'email'

  def welcome_email(current_user, new_user)  
    setup_email
    @recipients = [current_user.email, new_user.email].compact
    @subject += "Nuevo usuario"  
    @body = {:user => new_user, :url => "http://example.com/login"}
  end   

  #Nuevo mensaje recibido
  def new_message_received(receiver, message)
    setup_email
    @recipients = receiver.email
    @subject += "Nuevo mensaje recibido"  
    @body = {:sender => message.sender, :message => message}
  end

  def setup_email
    @from = "Andalucía sabor international fine food exhibition <andaluciasabor@andaluciasabor.es>"  
    @subject = "[Andalucía Sabor] "  
    @sent_on = Time.now 
    content_type = "text/html"
  end
end
