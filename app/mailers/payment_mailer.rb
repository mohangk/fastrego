class PaymentMailer < ActionMailer::Base
  default from: Setting.key('tournament_registration_email')

  def update_notification(payment)
    @payment = payment
    mail :to => payment.registration.user.email, :subject => 'Payment update notification' do |format|
      format.text
      format.html
    end
  end
end
