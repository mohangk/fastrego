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
        {key: Setting::PRE_REGISTRATION_FEES_PERCENTAGE, value: '0' },
        {key: Setting::ENABLE_PAYPAL_PAYMENT, value: 'False' },
        {key: 'observer_fees', value: '100'},
        {key: 'adjudicator_fees', value: '100'},
        {key: 'debate_team_fees', value: '200'},
        {key: 'debate_team_size', value: '3'},
        {key: 'tournament_name', value: 'Debate tournament name'},
        {key: 'currency_symbol',  value: 'USD'},
        {key: 'tournament_registration_email',  value: 'registration_email@test.com'}
    ]
    ss = settings.map { |s| Setting.new(s) }
    ss.each { |s| s.tournament = t ; s.save! }

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
  task :enable_paypal_payment, [:host_paypal_account, :tournament_identifier] do |t, args|
    t = Tournament.where(identifier: args.tournament_identifier).first
    raise "Cannot find tournament with identifier '#{args.tournament_identifier}'" if t.nil?
    puts "Enabling PayPal for '#{t.identifier}'"
    s = Setting.where(key:  Setting::ENABLE_PAYPAL_PAYMENT, tournament_id: t.id).first_or_initialize
    s.value = 'True'
    s.save!

    puts "Setting host_paypal_account '#{args.host_paypal_account}' for '#{t.identifier}'"
    s = Setting.where(key: 'host_paypal_account', tournament_id: t.id).first_or_initialize
    s.value = args.host_paypal_account
    s.save!
  end
end

