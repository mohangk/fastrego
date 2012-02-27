class Payment < ActiveRecord::Base
  belongs_to :registration
  has_attached_file :scanned_proof

  validates_attachment_presence :scanned_proof
  validates_attachment_size :scanned_proof, less_than: 3.megabytes
  validates_attachment_content_type :scanned_proof, content_type: %w(image/jpg image/png image/gif application/pdf)
  validates :registration, presence: true
  validates :account_number, presence: true
  validates :amount_sent, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :amount_received, numericality: { only_integer: true, greater_than_or_equal_to: 0 } , allow_blank: true
  validates :date_sent, presence: true

end