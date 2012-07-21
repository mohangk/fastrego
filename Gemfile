source 'http://rubygems.org'

gem 'rails', '3.2.5'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'activerecord-postgres-hstore'
gem 'unicorn'
gem 'sass-rails'
gem 'paperclip'
gem 'aws-sdk'
#putting this in so I can dupe data on beta-debreg
gem 'faker'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier'
  gem 'coffee-rails'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'devise'
# need this fix https://github.com/gregbell/active_admin/pull/623
gem 'activeadmin' , :git => 'git://github.com/gregbell/active_admin.git'
gem "strip_attributes"
gem 'meta_search'
gem 'newrelic_rpm'
gem 'simple_form'
gem 'country_select'
#gem 'country-select' - using http://github.com/rails/iso-3166-country-select instead as this did not seem to work
gem 'rack-google-analytics', :require => 'rack/google-analytics'

group :development, :test do
  gem 'sextant'
  gem 'foreman'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'#, require: false
  gem 'spork'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'debugger'
  gem 'poltergeist', git: 'https://github.com/jonleighton/poltergeist.git'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

