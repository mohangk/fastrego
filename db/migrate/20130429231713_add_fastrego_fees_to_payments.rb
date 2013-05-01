class AddFastregoFeesToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :fastrego_fees, :decimal, precision: 14, scale: 2
  end
end
