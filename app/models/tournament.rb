class Tournament < ActiveRecord::Base
  has_many :settings
  has_many :registrations
  belongs_to :admin_user
  validates :name, presence: true 
  validates :identifier, presence: true , uniqueness: true
end
