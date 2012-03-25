class Observer < Participant
  belongs_to :registration
  validates_presence_of :registration

end