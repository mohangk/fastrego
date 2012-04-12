class RegistrationMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']

  def slots_granted_notification(registration)
    @registration = registration 
    @notification_type = 'granted' 
    mail :to => registration.user.email, :subject => "#{@notification_type.capitalize} slots notification"  do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end
  
  def slots_confirmed_notification(registration)
    @registration = registration 
    @notification_type = 'confirmed' 
    mail :to => registration.user.email, :subject => "#{@notification_type.capitalize} slots notification"  do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end
end
