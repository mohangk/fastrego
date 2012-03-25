class Adjudicator < Participant
	belongs_to :registration
	validates_presence_of :registration

end