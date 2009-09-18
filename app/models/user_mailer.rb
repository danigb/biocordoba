class UserMailer < ActionMailer::Base
  layout 'email'

  def welcome_email(new_user)  
    setup_email
    @recipients = new_user.email
    @bcc = User.admins.map(&:email)
    @subject += "Nuevo usuario"  
    @body = {:user => new_user}
  end   

  def remember_password(user)
    setup_email
    @recipients = user.email
    @subject += "Recordatorio de contraseña"  
    @body = {:user => user}
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
    # @bcc = User.admins.map(&:email)
    @subject += "Su usuario ha sido desactivado"  
  end
  #Notificar a los usuarios extenda que han mandado un email a un usuario internacional

  def setup_email
    @from = "Andalucía Sabor international fine food exhibition <andaluciasabor@andaluciasabor.es>"  
    @subject = "[Agenda Andalucía Sabor] "  
    @sent_on = Time.now 
    @content_type = "text/html"
    # @bcc = ["info@beecoder.com"]
  end
end
