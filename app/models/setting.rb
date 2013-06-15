class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: { scope: :tournament_id }
  validates :tournament_id, presence: true
  belongs_to :tournament
  attr_accessible :key, :value

  HOST_PAYPAL_LOGIN = 'host_paypal_login'
  HOST_PAYPAL_PASSWORD = 'host_paypal_password'
  HOST_PAYPAL_SIGNATURE = 'host_paypal_signature'
  ENABLE_PRE_REGISTRATION = 'enable_pre_registration'
  ENABLE_PAYPAL_PAYMENT = 'enable_paypal_payment'
  PRE_REGISTRATION_FEES_PERCENTAGE = 'pre_registration_fees_percentage'
  PAYPAL_CURRENCY = 'paypal_currency'
  PAYPAL_CONVERSION_RATE = 'paypal_conversion_rate'

  def self.paypal_currency_conversion?(tournament)
    !Setting.paypal_conversion_rate(tournament).nil?
  end

  def self.paypal_currency(tournament)
    Setting.key(tournament, PAYPAL_CURRENCY)
  end

  def self.paypal_conversion_rate(tournament)
    rate = Setting.key(tournament, PAYPAL_CONVERSION_RATE)
    return rate if rate.nil?
    BigDecimal.new(rate)
  end

  def self.paypal_login(tournament)
    Setting.key(tournament, HOST_PAYPAL_LOGIN)
  end

  def self.paypal_password(tournament)
    Setting.key(tournament, HOST_PAYPAL_PASSWORD)
  end

  def self.paypal_signature(tournament)
    Setting.key(tournament, HOST_PAYPAL_SIGNATURE)
  end

  def self.currency_symbol(tournament)
    Setting.key(tournament, 'currency_symbol') ? Setting.key(tournament, 'currency_symbol') : 'USD'
  end

  def self.paypal_payment_enabled?(tournament)
    self.treat_as_bool Setting.key(tournament, Setting::ENABLE_PAYPAL_PAYMENT)
  end

  def self.pre_registration_fees_enabled?(tournament)
    percentage = Setting.key(tournament, Setting::PRE_REGISTRATION_FEES_PERCENTAGE)
    return false if percentage.nil?
    return true if percentage.to_d > 0
  end

  def self.pre_registration_fees_percentage(tournament)
    Setting.key(tournament, Setting::PRE_REGISTRATION_FEES_PERCENTAGE).to_d
  end

  def self.pre_registration_enabled?(tournament)
    self.treat_as_bool Setting.key(tournament, 'enable_pre_registration')
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

  private

  def self.treat_as_bool value
    return false if value.nil?
    value.downcase == 'true'
  end
end
