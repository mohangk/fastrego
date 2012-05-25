ActiveAdmin.register Participant do
  actions :all, :except => [:new, :edit]


  scope :all, default: true do |r|
    r.includes [ :registration => [ :user => :institution ]]
  end

  index do
    selectable_column
    column :id
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
    column 'Pref roommate', :preferred_roommate
    column 'Pref roomate institution', :preferred_roommate_institution
    column 'Spkr no.', :speaker_number
    column 'Team no.', :team_number
    column 'Depature', sortable: :departure_at do |r|
    	r.departure_at.strftime("%d/%m %H:%M:%S") unless r.departure_at.nil?
    end
    column :nationality
    column :passport_number
    column :transport_number
    default_actions
  end

  csv do
    column :id
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
    column :preferred_roommate
    column :preferred_roommate_institution
    column :speaker_number
    column :team_number
    column :departure_at do |r|
    	r.departure_at.strftime("%d/%m %H:%M:%S") unless r.departure_at.nil?
    end
    column :nationality
    column :passport_number
    column :transport_number
  end
  
  filter :registration_user_institution_name, as: :select, collection: proc { Institution.order(:name).all.map(&:name) }
  filter :name
  filter :gender, as: :check_boxes, collection: ['Male', 'Female'] 
  filter :type, as: :check_boxes, collection: ['Debater', 'Adjudicator', 'Observer'] 
  filter :dietary_requirement
  filter :allergies
  filter :email
  filter :point_of_entry
  filter :arrival_at
  filter :emergency_contact_person
  filter :emergency_contact_number
  filter :preferred_roommate
  filter :preferred_roommate_institution
  filter :speaker_number
  filter :team_number
  filter :departure_at
  filter :nationality
  filter :passport_number
  filter :transport_number
end
