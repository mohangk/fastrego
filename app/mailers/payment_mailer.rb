class PaymentMailer < ActionMailer::Base
  default from: "do-not-reply@uadc2012.mailgun.org"

  def update_notification(payment)
    @payment = payment
    mail :to => payment.registration.user.email, :subject => 'Payment update notification' do |format|
      format.text
      format.html
    end
  end
end
