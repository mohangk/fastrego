namespace :db do
  desc 'Adds the hstore extension to the database'
  task :create_hstore => :environment do
    sql = 'CREATE EXTENSION hstore';
    puts ActiveRecord::Base.connection.execute(sql)
  end
end
  
