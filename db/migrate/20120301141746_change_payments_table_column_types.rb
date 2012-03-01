class ChangePaymentsTableColumnTypes < ActiveRecord::Migration
  def up
    change_table :payments do |t|
      t.change :amount_sent, :decimal, precision: 8, scale: 2
      t.change :amount_received, :decimal, precision: 8, scale: 2
    end
  end

  def down
    change_table :payments do |t|
      t.change :amount_sent, :integer
      t.change :amount_received, :integer
    end
  end
end
