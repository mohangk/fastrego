namespace :fastrego do
  desc 'Adds the hstore extension to the database'
  task :add_hstore => :environment do
    sql = 'CREATE EXTENSION hstore';
    puts ActiveRecord::Base.connection.execute(sql)
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
  
