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
  #validates :transaction_txnid, presence: true

  def self.create registration

    @paypal_payment = PaypalPayment.new({:registration => registration,
                                         :date_sent => Date.today,
                                         :amount_sent => registration.balance_fees})

    @paypal_payment.primary_receiver = registration.paypal_recipients[0][:email]
    @paypal_payment.secondary_receiver = registration.paypal_recipients[1][:email]
    @paypal_payment.save!
    @paypal_payment
  end

  def initialize_status
    self.status = STATUS_DRAFT unless persisted?
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


end
