class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|

      execute "CREATE EXTENSION hstore"

      t.integer :registration_id
      t.string :name
      t.string :gender
      t.string :email
      t.string :dietary_requirement 
      t.string :allergies
      t.datetime :arrival_at
      t.string :point_of_entry
      t.string :emergency_contact_person
      t.string :emergency_contact_number
      t.string :preferred_roommate
      t.string :preferred_roommate_institution
      t.datetime :departure_at
      t.integer :speaker_number
      t.integer :team_number
      t.string :type
      t.string :nationality
      t.string :passport_number
      t.string :transport_number
      t.hstore :participants, :data
      t.timestamps
    end
  end
end
