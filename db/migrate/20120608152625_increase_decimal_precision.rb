class IncreaseDecimalPrecision < ActiveRecord::Migration
  def change
    change_column :registrations, :fees, :decimal, precision: 14, scale: 2 
    change_column :payments, :amount_sent, :decimal, precision: 14, scale: 2 

    change_column :payments, :amount_received, :decimal, precision: 14, scale: 2 
  end

end
