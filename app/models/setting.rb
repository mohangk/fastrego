class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  def self.method_missing(*args)
    if args.length == 1

      setting = self.find_by_key(args[0])
      if not setting.nil?
        setting.value
      end
    else
      super
    end
  end
end
