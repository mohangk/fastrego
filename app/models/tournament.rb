class Tournament < ActiveRecord::Base
  has_many :settings
  has_many :registrations
  belongs_to :admin_user
  validates :name, presence: true 
  validates :identifier, presence: true , uniqueness: true


  def pre_registration_enabled?
    Setting.key(self, 'enable_pre_registration') == 'True'
  end

  def currency_symbol
    Setting.currency_symbol(self)
  end
end
