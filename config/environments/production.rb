UadcRego::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'INFO')

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.assets.precompile += %w[admin/active_admin.css admin/active_admin.js]
  config.action_mailer.default_url_options = {:host => 'fastrego.com'}
  config.action_mailer.raise_delivery_errors = true


  Paperclip::Attachment.default_options.merge!({
    :storage => :s3,
    :bucket => ENV['S3_PRODUCTION_BUCKET'],
    :s3_credentials => {
      :access_key_id => ENV['S3_ACCESS_KEY_ID'],
      :secret_access_key => ENV['S3_SECRET_KEY']
    }
  })


  ActionMailer::Base.smtp_settings = {
      :port => ENV['MAILGUN_SMTP_PORT'],
      :address =>  ENV['MAILGUN_SMTP_SERVER'],
      :user_name => ENV['MAILGUN_SMTP_LOGIN'],
      :password => ENV['MAILGUN_SMTP_PASSWORD'],
      :domain => ENV['PRODUCTION_HOSTNAME'],
      :authentication => :plain,
  }
  ActionMailer::Base.delivery_method = :smtp

  ActiveMerchant::Billing::Base.mode = :test
  ::GATEWAY =  ActiveMerchant::Billing::PaypalAdaptivePayment.new(
    :login =>     ENV['PAYPAL_LOGIN'],     #"fastre_1356344930_biz_api1.gmail.com",
    :password =>  ENV['PAYPAL_PASSWORD'],  #"1356344950",
    :signature => ENV['PAYPAL_SIGNATURE'], #"Ata7WHUnSN0WA66.v.mkvBNYXyBsAvZP-x8joINtidDWenedQO5QIv0c",
    :appid =>     ENV['PAYPAL_APPID']      #"APP-80W284485P519543T"
  )

  ::FASTREGO_PAYPAL_ACCOUNT = 'fastre_1356344930_biz@gmail.com'


end
