class User < ActiveRecord::Base
  default_scope :include => :managed_registrations
  strip_attributes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,  :phone_number
  validates :name, presence: true
  has_many :managed_registrations, class_name: 'Registration', foreign_key: 'team_manager_id', dependent: :destroy

  #used to add attribute in activeadmin user form
  attr_writer :send_reset_password_email

  def send_reset_password_email
    true if @send_reset_password_email.nil?
  end

  #def registered?
  #  !self.registration.nil?
  #end
  
  def institution_name
    self.institution && self.institution.name
  end
end
