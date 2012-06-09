class AddDataColumnToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :data, :hstore
  end
end
