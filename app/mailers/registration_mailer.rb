class RegistrationMailer < ActionMailer::Base

  def slots_granted_notification(registration)
    @registration = registration
    @notification_type = 'granted'
    notification(@registration, @notification_type)
  end

  def slots_confirmed_notification(registration)
    @registration = registration
    @notification_type = 'confirmed'
    notification(@registration, @notification_type)
  end

  private

  def notification(registration, notification_type)
    from = Setting.key(registration.tournament, 'tournament_registration_email')
    subject = "[#{registration.tournament.identifier}] Updates to your #{@notification_type} slots!"
    to = registration.team_manager.email
    logger.error "REGISTRATION LOG => From: #{from}, To: #{to}, Subject: #{subject}"
    mail from: from, to: to, subject: subject do |format|
      format.text { render 'slots_notification' }
      format.html { render 'slots_notification' }
    end
  end
end
