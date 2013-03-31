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

  after_initialize :initialize_status
  validates :status, presence: true

  def self.generate registration

    @paypal_payment = PaypalPayment.new({:registration => registration,
                                         :amount_sent => registration.balance_fees})

    @paypal_payment.primary_receiver = registration.host_paypal_account
    @paypal_payment.secondary_receiver = ::FASTREGO_PAYPAL_ACCOUNT
    @paypal_payment.save!
    @paypal_payment
  end

  def initialize_status
    self.status = STATUS_DRAFT unless persisted?
  end

  def fastrego_fees_portion
    registration.fastrego_fees_portion
  end

  def secondary_receiver
    ::FASTREGO_PAYPAL_ACCOUNT
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


end
