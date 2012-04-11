class RegistrationMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']

  def slots_granted_notification(registration)
    self.slots_notification(registration, 'granted')
  end

  def slots_notification(registration, notification_type)
    @registration = registration 
    @notification_type = notification_type
    mail :to => registration.user.email, :subject => "#{@notification_type.capitalize} slots notification"  do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end

  def slots_confirmed_notification(registration)
    self.slots_notification(registration, 'confirmed')
  end
end
