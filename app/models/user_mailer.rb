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

  def new_message_to_international_user(receiver, message)
    setup_email
    @recipients = User.extendas.map(&:email)
    @subject += "Mensaje enviado a uno de tus compradores internacionales"  
    @body = {:sender => message.sender, :message => message, :receiver => receiver}
  end

  def user_disabled(receiver)
    setup_email
    @recipients = receiver.email
    @subject += "Su usuario ha sido desactivado"  
  end
  #Notificar a los usuarios extenda que han mandado un email a un usuario internacional

  def setup_email
    @from = "Andalucía sabor international fine food exhibition <andaluciasabor@andaluciasabor.es>"  
    @subject = "[Andalucía Sabor] "  
    @sent_on = Time.now 
    @content_type = "text/html"
  end
end
