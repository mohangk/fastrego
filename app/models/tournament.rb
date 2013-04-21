class Tournament < ActiveRecord::Base
  has_many :settings
  has_many :registrations
  belongs_to :admin_user
  validates :name, presence: true
  validates :identifier, presence: true , uniqueness: true


  def pre_registration_enabled?
    Setting.pre_registration_enabled?(self)
  end

  def currency_symbol
    Setting.currency_symbol(self)
  end

  def paypal_payment_enabled?
    Setting.paypal_payment_enabled?(self)
  end

  def pre_registration_fees_enabled?
    Setting.pre_registration_fees_enabled?(self)
  end

  def pre_registration_fees_percentage
    Setting.pre_registration_fees_percentage(self)
  end

  def url
    return "http://#{identifier}.fastrego.com"
  end
end


