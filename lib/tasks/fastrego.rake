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
    Setting.create(
      [
        {tournament: t, key: 'enable_pre_registration', value: 'False' },
        {tournament: t, key: 'observer_fees', value: '100'},
        {tournament: t, key: 'adjudicator_fees', value: '100'},
        {tournament: t, key: 'debate_team_fees', value: '200'},
        {tournament: t, key: 'debate_team_size', value: '3'},
        {tournament: t, key: 'tournament_name', value: 'Debate tournament name'},
        {tournament: t, key: 'currency_symbol',  value: 'USD'},
        {tournament: t, key: 'tournament_registration_email',  value: 'registration_email@test.com'}
      ])
  end

  desc 'Creates a tournament'
  task :create_tournament=> :environment
  task :create_tournament, [:identifier, :name, :admin_email] do |t, args|
    u = AdminUser.find_by_email!(args.admin_email)
    t = Tournament.create!(identifier: args.identifier, name: args.name, admin_user: u)
  end

  desc 'Creates the admin user'
  task :create_admin => :environment
  task :create_admin, [:tournament_identifier, :email, :password] do |t, args|
    AdminUser.create!(email: args.email, password: args.password, password_confirmation: args.password)
  end
end
  
