class AddsDatesAndTimestampsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :created_at, :datetime
    add_column :tournaments, :updated_at, :datetime
    add_column :tournaments, :registration_start, :date
    add_column :tournaments, :registration_end, :date
    add_column :tournaments, :tournament_start, :date
    add_column :tournaments, :tournament_end, :date
  end
end
