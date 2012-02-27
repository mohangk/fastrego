class AddAttachmentScannedProofToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :scanned_proof_file_name, :string
    add_column :payments, :scanned_proof_content_type, :string
    add_column :payments, :scanned_proof_file_size, :integer
    add_column :payments, :scanned_proof_updated_at, :datetime
  end

  def self.down
    remove_column :payments, :scanned_proof_file_name
    remove_column :payments, :scanned_proof_content_type
    remove_column :payments, :scanned_proof_file_size
    remove_column :payments, :scanned_proof_updated_at
  end
end
