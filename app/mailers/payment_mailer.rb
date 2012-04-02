class PaymentMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']

  def update_notification(payment)
    @payment = payment
    mail :to => payment.registration.user.email, :subject => 'Payment update notification' do |format|
      format.text
      format.html
    end
  end
end
