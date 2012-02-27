class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :account_number
      t.integer :amount_sent
      t.date :date_sent
      t.text :comments
      t.integer :amount_received
      t.text :admin_comment
      t.integer :registration_id

      t.timestamps
    end
  end
end
