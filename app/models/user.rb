class User < ActiveRecord::Base
  default_scope :include => :registration
  strip_attributes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable,  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :institution_id, :phone_number
  validates :institution_id, presence: true, uniqueness: true
  validates :name, presence: true
  belongs_to :institution
  has_one :registration, dependent: :destroy

  #def after_initialize
  #  self.registration ||= Registration.new
  #end

  def registered?
    !self.registration.nil?
    #!self.registration.new_record?
  end
end
