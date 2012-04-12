class ParticipantModification < ActiveRecord::Migration
  def change
     change_table :participants do |t|
      t.rename :preferred_roomate, :preferred_roommate
      t.rename :preferred_roomate_institution, :preferred_roommate_institution
      t.string :nationality
      t.string :passport_number
      t.rename :airport, :point_of_entry
      t.string :transport_number
    end
  end
end
