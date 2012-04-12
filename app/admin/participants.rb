ActiveAdmin.register Participant do

  index do
  	column :name
  	column :gender
  	column :type
  	column 'Diet',:dietary_requirement
  	column :allergies
  	column :email
  	column :airport
    column 'Arrival', sortable: :requested_at do |r|
      r.arrival_at.strftime("%d/%m %H:%M:%S") unless r.arrival_at.nil?
    end
    column 'Emer cnt person',:emergency_contact_person
    column 'Emer cnt number',:emergency_contact_number
    column 'Spkr no.', :speaker_number
    column 'Team no.', :team_number
    column 'Depature', sortable: 'institutions.abbreviation' do |r|
    	r.departure_at.strftime("%d/%m %H:%M:%S")
    end
    default_actions
  end
end
