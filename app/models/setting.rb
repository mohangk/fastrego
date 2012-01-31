class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  def self.method_missing(*args)
    if args.length == 1
      puts "me here"
      puts args[0]
      self.find_by_key(args[0]).value
    else
      super
    end
  end
end
