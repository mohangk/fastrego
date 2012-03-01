class ChangeRegistrationFeesColumn < ActiveRecord::Migration
  def up
    change_table :registrations do |t|
      t.change :fees, :decimal, precision: 8, scale: 2
    end
  end

  def down
    change_table :registrations do |t|
      t.change :fees, :integer
    end
  end
end
