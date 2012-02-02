ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'uadc2012.herokuapp.com',
  :user_name            => 'uadc2012rego', # full email address (user@your.host.name.com)
  :password             => 'tatelogan',
  :authentication       => 'plain',
  :enable_starttls_auto => true
}