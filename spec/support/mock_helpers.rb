require 'ostruct'

module MockHelperMethods

  @@pre_registration_enabled = false
  @@pre_registration_fees_enabled = false
  @@paypal_payment_enabled = false

  def current_tournament
    OpenStruct.new(currency_symbol: 'RM',
                   pre_registration_enabled?: @@pre_registration_enabled,
                   pre_registration_fees_enabled?: @@pre_registration_fees_enabled,
                   paypal_payment_enabled?: @@paypal_payment_enabled,
                   name: 'MMU Worlds')
  end

  def self.set_pre_registration_enabled(enabled)
    @@pre_registration_enabled = enabled
  end

  def self.paypal_payment_enabled=(enabled)
    @@paypal_payment_enabled = enabled
  end

  def self.pre_registration_fees_enabled=(enabled)
    @@pre_registration_fees_enabled = enabled
  end

end
