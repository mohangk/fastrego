class PaypalPayment < Payment

  after_initialize :initialize_status
  validates :status, presence: true
  validates :transaction_txnid, presence: true


  def initialize_status
    self.status = 'Draft' unless persisted?
  end

  def deleteable?
    false
  end

end
