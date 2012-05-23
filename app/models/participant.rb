class Participant < ActiveRecord::Base
  belongs_to :registration, dependent: :destroy
	validates_presence_of :name, :gender, :email, :dietary_requirement, :emergency_contact_person, :emergency_contact_number, :registration
end
