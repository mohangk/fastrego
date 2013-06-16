class PaypalPayment < Payment

  # Status of transaction from notification. List of possible values:
  # <tt>CREATED</tt>::
  # <tt>COMPLETED</tt>::
  # <tt>INCOMPLETE</tt>::
  # <tt>ERROR</tt>::
  # <tt>REVERSALERROR</tt>::
  # <tt>PROCESSING</tt>::
  # <tt>PENDING</tt>::
  STATUS_DRAFT = 'Draft'
  STATUS_PENDING = 'Pending'
  STATUS_COMPLETED = 'Completed'
  STATUS_PARTIAL = 'Partial'
  STATUS_CANCELED = 'Canceled'
  STATUS_FAIL = 'Fail'

  FASTREGO_FEES = 0.05

  after_initialize :initialize_status
  validates :status, presence: true

  def self.generate registration, pre_registration = false

    paypal_payment = PaypalPayment.new
    paypal_payment.registration = registration
    if pre_registration
      paypal_payment.details = "Pre registration fees for #{paypal_payment.receiver}"
      registration_fees = registration.balance_pre_registration_fees
    else
      paypal_payment.details = "Registration fees for #{paypal_payment.receiver}"
      registration_fees = registration.balance_fees
    end
    paypal_payment.currency = registration_fees.currency
    paypal_payment.conversion_currency = registration_fees.conversion_currency
    paypal_payment.conversion_rate = registration_fees.conversion_rate
    paypal_payment.fastrego_fees = calculate_fastrego_fees(registration_fees)
    paypal_payment.amount_sent = registration_fees +  paypal_payment.fastrego_fees
    paypal_payment.save!
    paypal_payment
  end


  def conversion_rate=(rate)
    self[:conversion_rate] = rate.to_s
  end

  def conversion_rate
    BigDecimal.new(self[:conversion_rate] || '1')
  end

  def initialize_status
    self.status = STATUS_DRAFT unless persisted?
  end

  def receiver
    registration.tournament.name
  end

  def deleteable?
    false
  end

  def update_pay_key payKey
    self.update_attributes!(status: STATUS_PENDING, transaction_txnid: payKey)
  end

  def cancel!
    self.update_attributes!(status: PaypalPayment::STATUS_CANCELED)
  end

  def date_sent
    created_at
  end


  def self.calculate_fastrego_fees fees
    calculated_fastrego_fees = (fees.conversion_amount * FASTREGO_FEES).round(2)
    if calculated_fastrego_fees < 4.00
      calculated_fastrego_fees = 4
    end
    (calculated_fastrego_fees/fees.conversion_rate).round(2)
  end

  def fastrego_fees_as_convertible_money
    ConvertibleMoney.new(currency, fastrego_fees,
                         {conversion_rate: conversion_rate, conversion_currency: conversion_currency})
  end

  def amount_sent_as_convertible_money
    ConvertibleMoney.new(currency, amount_sent,
                         {conversion_rate: conversion_rate, conversion_currency: conversion_currency})
  end

  def registration_fees
    return 0 if amount_sent.nil?
    amount_sent - ( fastrego_fees.nil? ? 0 : fastrego_fees)
  end

  def registration_fees_as_convertible_money
    ConvertibleMoney.new(currency, registration_fees, {conversion_rate: conversion_rate, conversion_currency: conversion_currency})
  end


  alias_attribute :details, :comments
  alias_attribute :details=, :comments=
end
