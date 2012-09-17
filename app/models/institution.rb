class Institution < ActiveRecord::Base
  scope :alphabetically, order("name")
  strip_attributes
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true, length: {maximum: 10}
  validates :country, presence: true

  has_many :registrations, dependent: :nullify

  def self.participating(tournament_identifier, admin_user)
    Institution.joins(registrations: :tournament).where('tournaments.identifier = ? and tournaments.admin_user_id = ?', tournament_identifier, admin_user.id)
  end


  def self.paid_participating(tournament_identifier, admin_user)
    self.participating(tournament_identifier, admin_user).joins(registrations: :payments)
  end
end
