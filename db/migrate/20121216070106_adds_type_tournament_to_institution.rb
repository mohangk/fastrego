class AddsTypeTournamentToInstitution < ActiveRecord::Migration

  def change
    add_column :institutions, :type, :string
    add_column :institutions, :tournament_id, :integer
    execute <<-SQL
      UPDATE institutions
      SET type = 'University'
      WHERE type is NULL
    SQL
  end

end