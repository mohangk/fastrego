class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:email, :subdomain]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :subdomain
  has_many :tournaments, dependent: :nullify
  has_many :registrations, through: :tournaments 
  has_many :team_managers, through: :registrations


  def self.find_for_authentication(conditions={})
    conditions = conditions.dup
    subdomain = conditions.delete(:subdomain)
    where(conditions).includes(:tournaments).where('tournaments.identifier=?',subdomain).first
  end
end
