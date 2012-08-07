class Tournament < ActiveRecord::Base
  has_many :settings
  has_many :registrations
  belongs_to :admin_user
  validates_presence_of :name, :identifier
  
end
