class AddFeesToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :fees, :integer
  end
end
