class Tournament < ActiveRecord::Base
  has_many :settings
  has_many :registrations
  belongs_to :admin_user
  validates :name, presence: true
  validates :identifier, presence: true , uniqueness: true


  def to_convertible_currency(amount)

    conversion_options  = {}

    if paypal_currency_conversion?
      conversion_options = {
        conversion_currency: paypal_currency,
        conversion_rate: paypal_conversion_rate,
      }
    end

    ConvertibleMoney.new(
      currency_symbol,
      amount,
      conversion_options
    )

  end

  def paypal_currency_conversion?
    Setting.paypal_currency_conversion?(self)
  end

  def paypal_currency
    Setting.paypal_currency(self)
  end

  def paypal_conversion_rate
    Setting.paypal_conversion_rate(self)
  end

  def paypal_login
    Setting.paypal_login(self)
  end

  def paypal_password
    Setting.paypal_password(self)
  end

  def paypal_signature
    Setting.paypal_signature(self)
  end

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


