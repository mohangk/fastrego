class PaymentMailer < ActionMailer::Base
  #default from: Setting.key('tournament_registration_email')


  def update_notification(payment)
    @payment = payment
    mail from: Setting.key(payment.registration.tournament, 'tournament_registration_email'), to: payment.registration.team_manager.email, subject:  "[#{payment.registration.tournament.identifier}] Payment update notification" do |format|
      format.text
      format.html
    end
  end
end
