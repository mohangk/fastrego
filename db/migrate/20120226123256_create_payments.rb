class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :account_number
      t.decimal :amount_sent, precision: 14, scale: 2
      t.date :date_sent
      t.text :comments
      t.decimal :amount_received, precision: 14, scale: 2
      t.text :admin_comment
      t.integer :registration_id
      t.string :scanned_proof_file_name
      t.string :scanned_proof_content_type
      t.integer :scanned_proof_file_size
      t.datetime :scanned_proof_updated_at

      t.timestamps
    end
  end
end
