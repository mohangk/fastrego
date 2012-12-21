class OpenInstitution < Institution
  
  belongs_to :tournament

  validates :tournament, presence: true

end
