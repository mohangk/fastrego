class PaymentMailer < ActionMailer::Base
  default from: Setting.key('tournament_registration_email')

  def self.tournament_identifier
    default_url_options[:host].split('.')[0]
  end

  def update_notification(payment)
    @payment = payment
    mail :to => payment.registration.user.email, :subject => "[#{RegistrationMailer.tournament_identifier}] Payment update notification" do |format|
      format.text
      format.html
    end
  end
end
