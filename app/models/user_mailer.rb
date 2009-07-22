class UserMailer < ActionMailer::Base
  def welcome_email(current_user, new_user, password)  
    recipients [current_user.email, new_user.email]
    from "Awesome Site Notifications <notifications@example.com>"  
    subject "[AndalucíaSabor] Nuevo usuario"  
    sent_on Time.now 
    body( {:user => new_user, :password => password, :url => "http://example.com/login"})  
  end   
end