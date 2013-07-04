ActiveAdmin.register Participant do
  actions :all, :except => [:new, :edit]

  scope_to association_method: :call do
    lambda { Participant.where(registration_id: Registration.for_tournament(current_subdomain, current_admin_user).collect { |r| r.id }) }
  end

  controller do
    def index
      Participant.custom_fields(current_subdomain).each do | field|
        if active_admin_config.csv_builder.columns.select { |c| c.name == field.titleize }.count == 0
          active_admin_config.csv_builder.column field.to_sym
        end
      end
      index!
    end
  end

  index do
    selectable_column
    column :id
    column 'Inst',sortable: 'institutions.abbreviation' do |p|
        link_to p.registration.institution.abbreviation, admin_institution_path(p.registration.institution)
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
    Participant.custom_fields(current_subdomain).each do | field|
      column field.to_sym, sortable: false
    end

    default_actions
  end


  csv do
    column :id
    column('Inst') do |p|
      p.registration.institution.abbreviation
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

  show do |p|
    attributes_table do
      row :id
      row 'Inst' do
          link_to p.registration.institution.abbreviation, admin_institution_path(p.registration.institution)
      end
      row :name
      row :gender
      row :type
      row :dietary_requirement
      row :allergies
      row :email
      row :point_of_entry
      row 'Arrival' do
        p.arrival_at.strftime("%d/%m %H:%M:%S") unless p.arrival_at.nil?
      end

      row 'Emer cnt person' do
        p.emergency_contact_person
      end

      row 'Emer cnt number'do
        p.emergency_contact_number
      end

      row 'Pref roommate'do
        p.preferred_roommate
      end

      row 'Pref roomate institution'do
        p.preferred_roommate_institution
      end

      row 'Spkr no.'do
        p.speaker_number
      end

      row 'Team no.'do
        p.team_number
      end

      row 'Depature'  do
        p.departure_at.strftime("%d/%m %H:%M:%S") unless p.departure_at.nil?
      end

      row :nationality
      row :passport_number
      row :transport_number

      Participant.custom_fields(current_subdomain).each do | field|
        row field.to_sym
      end
    end
    active_admin_comments
  end

  filter :registration_institution_name, as: :select, collection: proc { Institution.participating(current_subdomain, current_admin_user).order(:name).all.map(&:name) }
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
