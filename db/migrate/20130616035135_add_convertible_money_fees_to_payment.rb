class AddConvertibleMoneyFeesToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :conversion_currency, :string
    add_column :payments, :conversion_rate, :string
  end
end
