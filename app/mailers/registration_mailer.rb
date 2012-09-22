class RegistrationMailer < ActionMailer::Base

  def slots_granted_notification(registration)
    @registration = registration 
    @notification_type = 'granted' 
    mail from: Setting.key(registration.tournament, 'tournament_registration_email'),:to => registration.team_manager.email, :subject => "[#{registration.tournament.identifier}] Updates to your #{@notification_type} slots!"  do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end
  
  def slots_confirmed_notification(registration)
    @registration = registration 
    @notification_type = 'confirmed' 
    mail :to => registration.team_manager.email, :subject => "[#{registration.tournament.identifier}] Updates to your #{@notification_type} slots!"  do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end
end
