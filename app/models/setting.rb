class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  def self.key(key, value=nil)

    if value.nil?
      setting = self.find_by_key(key)
      if not setting.nil?
        setting.value
      end
    else
      setting = self.find_by_key(key)
      if setting.nil?
        setting = Setting.new
        setting.key = key
      end
      setting.value = value
      setting.save
      setting.reload
    end
  end
end
