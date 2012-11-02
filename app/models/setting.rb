class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: { scope: :tournament_id }
  validates :tournament_id, presence: true
  belongs_to :tournament
  attr_accessible :key, :value

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
        setting = Setting.new(key: key) 
      end
      setting.tournament_id = tournament.id
      setting.value = value
      setting.save!
    end
  end

  def self.for_tournament(tournament_identifier, admin_user)
    Setting.includes(:tournament)
    .where('tournaments.identifier = ? and tournaments.admin_user_id = ?', tournament_identifier, admin_user.id)
  end
end
