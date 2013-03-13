class ManualPayment < Payment

  STATUS_PENDING = 'Pending'
  STATUS_COMPLETED = 'Completed'

  has_attached_file :scanned_proof
  
  validates_attachment_presence :scanned_proof, message: ' must be provided. Please scan the physical transfer document receipt or create a screen capture of electronic transfers and include as proof'
  validates_attachment_size :scanned_proof, less_than: 3.megabytes, message: ' file size must be less then 3 megabytes'
  validates_attachment_content_type :scanned_proof, content_type: %w(image/jpeg image/png image/gif application/pdf), message: 'file type must be of an image (GIF/JPG/PNG) or PDF'
  validates :account_number, presence: { message: "can't be blank. Please key in the account this transfer was made from"}
  validates :amount_received, numericality: { greater_than_or_equal_to: 0 } , allow_blank: true
  validates :date_sent, presence: true


  attr_accessible :account_number, :amount_sent, :date_sent, :comments, :scanned_proof

  HUMANIZED_ATTRIBUTES = {
    #amount_sent: (Setting.table_exists? ? Setting.key('currency_symbol') : 'USD'),
    account_number: 'A/C #',
    scanned_proof: 'Proof of transfer',
    scanned_proof_content_type: 'Proof of transfer',
    scanned_proof_file_size: 'Proof of transfer',
    date_sent: 'Date',
    #TODO - Below is ugly partial workaround for double error message due to  validates_attachment_presence - must check
    scanned_proof_file_name: 'Proof of transfer'
  }
  
  def deleteable?
    !confirmed?
  end

  def confirmed?
    !(self.amount_received.blank? and self.admin_comment.blank?)
  end

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  def institution_name
    self.registration.user.institution.name
  end

  def send_payment_notification
    PaymentMailer.update_notification(self).deliver
  end

  def destroyable?(user = nil)
    if user.nil?
      !confirmed?
    else
      !confirmed? and owner?(user)
    end
  end

  def status
    if (amount_received || 0) - amount_sent >= 0
      STATUS_COMPLETED
    else
      STATUS_PENDING
    end
  end

end
