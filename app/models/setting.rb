class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true

  def self.currency_symbol
    Setting.key('currency_symbol') ? Setting.key('currency_symbol') : 'USD'
  end

  def self.key(key, value=nil)
    return nil unless Setting.table_exists? 

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
