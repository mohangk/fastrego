class AddConfirmable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.confirmable
    end
  end
end
