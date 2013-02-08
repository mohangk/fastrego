class Payment < ActiveRecord::Base
  belongs_to :registration
  validates :registration, presence: true
  validates :date_sent, presence: true

  def self.confirmed
    where("amount_received is not null")
  end

  def self.unconfirmed
    where("amount_received is null")
  end

  def confirmed?
    !(self.amount_received.blank? and self.admin_comment.blank?)
  end

  def deleteable?
    raise NotImplementedError
  end

  def owner?(user)
    user == registration.team_manager
  end
end
