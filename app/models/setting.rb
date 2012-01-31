class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  def self.key(key, value=nil)
    setting = self.find_by_key(key)

    if value.nil?
      if not setting.nil?
        setting.value
      end
    else
      if setting.nil?
        setting = Setting.new
        setting.key = key
      end
      setting.value = value
      setting.save
    end
  end
end
