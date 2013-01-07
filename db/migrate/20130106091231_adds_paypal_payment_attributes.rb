class AddsPaypalPaymentAttributes < ActiveRecord::Migration
  def change
    add_column :payments, :type, :string
    add_column :payments, :status, :string
    add_column :payments, :transaction_txnid, :string
    add_column :payments, :invoice_number, :string
    add_column :payments, :primary_receiver, :string
    add_column :payments, :secondary_receiver, :string
  end
end
