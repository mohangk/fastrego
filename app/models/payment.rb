class Payment < ActiveRecord::Base
  belongs_to :registration
  has_attached_file :scanned_proof

  validates_attachment_presence :scanned_proof, message: ' must be provided. Please scan the physical transfer document receipt or create a screen capture of electronic transfers and include as proof'
  validates_attachment_size :scanned_proof, less_than: 3.megabytes, message: ' file size must be less then 3 megabytes'
  validates_attachment_content_type :scanned_proof, content_type: %w(image/jpeg image/png image/gif application/pdf), message: 'file type must be of an image (GIF/JPG/PNG) or PDF'
  validates :registration, presence: true
  validates :account_number, presence: { message: "can't be blank. Please key in the account this transfer was made from"}
  validates :amount_sent, presence: { message: "can't be blank. Please key in the amount in Malaysian Ringgit that you have transfered"}, numericality: {  greater_than_or_equal_to: 0, if: Proc.new { |p| not p.amount_sent.blank? } }
  validates :amount_received, numericality: { greater_than_or_equal_to: 0 } , allow_blank: true

  validates :date_sent, presence: true

  attr_accessible :account_number, :amount_sent, :date_sent, :comments, :scanned_proof

  HUMANIZED_ATTRIBUTES = {
    amount_sent: 'RM',
    account_number: 'A/C #',
    scanned_proof: 'Proof of transfer',
    scanned_proof_content_type: 'Proof of transfer',
    scanned_proof_file_size: 'Proof of transfer',
    date_sent: 'Date',
    #TODO - Below is ugly partial workaround for double error message due to  validates_attachment_presence - must check
    scanned_proof_file_name: 'Proof of transfer'
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end