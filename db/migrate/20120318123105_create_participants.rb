class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
	  t.integer :registration_id
	  t.string :name
	  t.string :gender
	  t.string :email
	  t.string :dietary_requirement 
	  t.string :allergies
	  t.datetime :arrival_at
	  t.string :airport
	  t.string :emergency_contact_person
	  t.string :emergency_contact_number
	  t.string :preferred_roomate
	  t.string :preferred_roomate_institution
	  t.datetime :departure_at
	  t.integer :speaker_number
	  t.integer :team_number
	  t.string :type
      t.timestamps
    end
  end
end
