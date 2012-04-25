class EnquiryMailer < ActionMailer::Base
  default from: ENV['MAILGUN_SMTP_LOGIN']

  def send_enquiry(enquiry)
    @enquiry = enquiry 
    mail to: 'loganimal@gmail.com', cc: 'mohangk@gmail.com', subject: 'Someone made a FastRego enquiry!' do |format|
      format.text
    end
  end
end
