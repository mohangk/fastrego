class Payment < ActiveRecord::Base
  belongs_to :registration

  validates :registration, presence: true
  validates :amount_sent, presence:  { message: "can't be blank. Please key in the amount that you have transfered"}, numericality: {  greater_than_or_equal_to: 0, if: Proc.new { |p| not p.amount_sent.blank? } }

  default_scope order('created_at')

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
