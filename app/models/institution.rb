class Institution < ActiveRecord::Base
  scope :alphabetically, order("name")
  strip_attributes
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true, length: {maximum: 10}
  validates :country, presence: true

  has_many :registrations, dependent: :nullify
end
