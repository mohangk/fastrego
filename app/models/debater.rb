class Debater < Participant
  belongs_to :registration
  validates_presence_of :team_number, :speaker_number, :registration
  scope :for_team, lambda { |registration_id, team_number| where(registration_id: registration_id, team_number: team_number) }

  def team_name 
  	return "#{self.registration.institution.abbreviation} #{self.team_number}"
  end

end
