#class ActiveRecord::Base
#  mattr_accessor :shared_connection
#  @@shared_connection = nil
#
#  def self.connection
#    @@shared_connection || retrieve_connection
#  end
#end
#ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
