namespace :fastrego do
  desc 'Adds the hstore extension to the database'
  task :add_hstore => :environment do
    sql = 'CREATE EXTENSION hstore';
    puts ActiveRecord::Base.connection.execute(sql)
  end

  desc 'Adds default settings'
  task :create_settings => :environment
  task :create_settings, [:tournament_identifier] do |t, args|
    t = Tournament.find_by_identifier(args.tournament_identifier)
    puts "Create setting for '#{t.identifier}'"

    settings = [
        {key: Setting::ENABLE_PRE_REGISTRATION, value: 'False' },
        {key: Setting::PRE_REGISTRATION_FEES_PERCENTAGE, value: '0' },
        {key: 'observer_fees', value: '100'},
        {key: 'adjudicator_fees', value: '100'},
        {key: 'debate_team_fees', value: '200'},
        {key: 'debate_team_size', value: '3'},
        {key: 'tournament_name', value: 'Debate tournament name'},
        {key: 'currency_symbol',  value: 'USD'},
        {key: 'tournament_registration_email',  value: 'registration_email@test.com'}]

    settings.each do |s|
      s = Setting.where(tournament_id: t.id, key: s[:key]).first_or_initialize
      next if s.persisted?
      s.value = s[:value]
      s.save!
    end

  end

  desc 'Creates a tournament'
  task :create_tournament=> :environment
  task :create_tournament, [:identifier, :name, :admin_email] do |t, args|
    u = AdminUser.find_by_email!(args.admin_email)
    t = Tournament.create!(identifier: args.identifier, name: args.name, admin_user: u, active: true)
  end

  desc 'Creates the admin user'
  task :create_admin => :environment
  task :create_admin, [:email, :password] do |t, args|
    AdminUser.create!(email: args.email, password: args.password, password_confirmation: args.password)
  end

  desc 'Enable PayPal payment'
  task :enable_paypal_payment => :environment
  task :enable_paypal_payment, [:host_paypal_login, :host_paypal_password, :host_paypal_signature, :tournament_identifier] do |t, args|
    t = Tournament.where(identifier: args.tournament_identifier).first
    raise "Cannot find tournament with identifier '#{args.tournament_identifier}'" if t.nil?
    puts "Enabling PayPal for '#{t.identifier}'"
    s = Setting.where(key:  Setting::ENABLE_PAYPAL_PAYMENT, tournament_id: t.id).first_or_initialize
    s.value = 'True'
    s.save!

    puts "Setting host_paypal_login '#{args.host_paypal_login}' for '#{t.identifier}'"
    s = Setting.where(key: Setting::HOST_PAYPAL_LOGIN, tournament_id: t.id).first_or_initialize
    s.value = args.host_paypal_login
    s.save!

    puts "Setting host_paypal_password '#{args.host_paypal_password}' for '#{t.identifier}'"
    s = Setting.where(key: Setting::HOST_PAYPAL_PASSWORD, tournament_id: t.id).first_or_initialize
    s.value = args.host_paypal_password
    s.save!

    puts "Setting host_paypal_signature '#{args.host_paypal_signature}' for '#{t.identifier}'"
    s = Setting.where(key: Setting::HOST_PAYPAL_SIGNATURE, tournament_id: t.id).first_or_initialize
    s.value = args.host_paypal_signature
    s.save!
  end

  task :clean_institutions => :environment
  task :clean_institutions do |t|
    Institution.where(country: 'Afghanistan').map {|i| puts i; i.destroy if i.registrations.blank? }
  end
end

