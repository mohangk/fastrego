class Institution < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true
  validates :country, presence: true, uniqueness: true

  has_one :user
end
