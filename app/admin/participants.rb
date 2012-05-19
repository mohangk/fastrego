ActiveAdmin.register Participant do
  scope :all, default: true do |r|
    r.includes [ :registration => [ :user => :institution ]]
  end

  index do
    column 'Inst',sortable: 'institutions.abbreviation' do |p|
        link_to p.registration.user.institution.abbreviation, admin_institution_path(p.registration.user.institution)
    end

  	column :name
  	column :gender
  	column :type
  	column 'Diet',:dietary_requirement
  	column :allergies
  	column :email
  	column :point_of_entry
    column 'Arrival', sortable: :arrival_at do |r|
      r.arrival_at.strftime("%d/%m %H:%M:%S") unless r.arrival_at.nil?
    end
    column 'Emer cnt person',:emergency_contact_person
    column 'Emer cnt number',:emergency_contact_number
    column 'Spkr no.', :speaker_number
    column 'Team no.', :team_number
    column 'Depature', sortable: :departure_at do |r|
    	r.departure_at.strftime("%d/%m %H:%M:%S") unless r.departure_at.nil?
    end
    default_actions
  end

  csv do
    column('Inst') do |p|
      p.registration.user.institution.abbreviation
    end
    column :name
  	column :gender
  	column :type
  	column :dietary_requirement
  	column :allergies
  	column :email
  	column :point_of_entry
    column :arrival_at do |p| 
      p.arrival_at.strftime("%d/%m %H:%M:%S") unless p.arrival_at.nil?
    end
    column :emergency_contact_person
    column :emergency_contact_number
    column :speaker_number
    column :team_number
    column :departure_at do |r|
    	r.departure_at.strftime("%d/%m %H:%M:%S") unless r.departure_at.nil?
    end
  end
  
  filter :registration_user_institution_name, as: :select, collection: Institution.order(:name).all.map(&:name)
  filter :name
  filter :gender
  filter :type
  filter :dietary_requirement
  filter :allergies
  filter :email
  filter :point_of_entry
  filter :arrival_at
  filter :emergency_contact_person
  filter :emergency_contact_number
  filter :speaker_number
  filter :team_number
  filter :departure_at

end
