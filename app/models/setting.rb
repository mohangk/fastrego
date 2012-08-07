class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  validates :tournament_id, presence: true
  belongs_to :tournament


  def self.currency_symbol(tournament)
    Setting.key(tournament, 'currency_symbol') ? Setting.key(tournament, 'currency_symbol') : 'USD'
  end

  def self.key(tournament, key, value=nil)
    return nil unless Setting.table_exists? 

    setting = self.find_by_tournament_id_and_key(tournament.id, key)

    if value.nil?
      if not setting.nil?
        setting.value
      end
    else
      if setting.nil?
        setting = Setting.new(tournament_id: tournament.id, key: key) 
      end
      setting.value = value
      setting.save
    end
  end
end
