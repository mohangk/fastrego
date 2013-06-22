class SendBatchEmail

  FASTREGO_MAILGUN_DOMAIN = 'fastrego.mailgun.com'

  def initialize(users, subject, message, from)
    RestClient.post(messaging_api_end_point,
    from: from,
    to: users.map(&:email).join(", "),
    subject: subject,
    text: message,
    :"recipient-variables" => recipient_variables(users)
    )
  end

  private

  def messaging_api_end_point
    @messaging_api_end_piont ||= "https://api:#{ENV["MAILGUN_API_KEY"]}@api.mailgun.net/v2/#{FASTREGO_MAILGUN_DOMAIN}/messages"
  end

  def recipient_variables(recipients)
    vars = recipients.map do |recipient|
      "\"#{recipient.email}\": {\"name\":\"#{recipient.name}\"}"
    end
    "{#{vars.join(', ')}}"
  end

end
