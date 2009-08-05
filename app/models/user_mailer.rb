class UserMailer < ActionMailer::Base
  def welcome_email(current_user, new_user)  
    recipients [current_user.email, new_user.email].compact
    from "Andalucía Sabor International Fine Food Exhibition <andaluciasabor@andaluciasabor.es>"  
    subject "[Andalucía Sabor] Nuevo usuario"  
    sent_on Time.now 
    body( {:user => new_user, :url => "http://example.com/login"})  
  end   

  #Nuevo mensaje recibido

end
