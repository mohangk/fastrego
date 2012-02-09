class Institution < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :abbreviation, presence: true, uniqueness: true, length: {maximum: 10}
  validates :country, presence: true

  has_one :user, dependent: :destroy
end
