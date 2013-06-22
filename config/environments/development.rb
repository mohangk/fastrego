UadcRego::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'test.com:5000' }

  #Paperclip::Attachment.default_options.merge!({
  #  :storage => :s3,
  #  :bucket => ENV['S3_DEVELOPMENT_BUCKET'],
  #  :s3_credentials => {
  #    :access_key_id => ENV['S3_ACCESS_KEY_ID'],
  #    :secret_access_key => ENV['S3_SECRET_KEY']
  #  }
  #})

  ActiveMerchant::Billing::Base.mode = :test
  #::GATEWAY =  ActiveMerchant::Billing::PaypalAdaptivePayment.new(
  #  :login => "fastre_1356344930_biz_api1.gmail.com",
  #  :password => "1356344950",
  #  :signature => "Ata7WHUnSN0WA66.v.mkvBNYXyBsAvZP-x8joINtidDWenedQO5QIv0c",
  #  :appid => "APP-80W284485P519543T" )

  # ::GATEWAY =  ActiveMerchant::Billing::PaypalExpressGateway.new(
  #   :login => "fastre_1356344930_biz_api1.gmail.com",
  #   :password => "1356344950",
  #   :signature => "Ata7WHUnSN0WA66.v.mkvBNYXyBsAvZP-x8joINtidDWenedQO5QIv0c",
  #   :appid => "APP-80W284485P519543T" )

  # ::FASTREGO_PAYPAL_ACCOUNT = 'fastre_1356344930_biz@gmail.com'

  require Rails.root.join 'lib/stub_gateway'
  require Rails.root.join 'lib/stub_send_batch_email'
end
