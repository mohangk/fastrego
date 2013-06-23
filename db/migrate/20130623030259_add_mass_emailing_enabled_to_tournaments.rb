class AddMassEmailingEnabledToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments,  :mass_emailing_enabled, :boolean, default: false
  end
end
