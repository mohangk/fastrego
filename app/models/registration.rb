class Registration < ActiveRecord::Base
  strip_attributes

  belongs_to :user
  has_many :payments

  attr_accessor :override_fees
  attr_accessible :debate_teams_requested, :adjudicators_requested, :observers_requested

  validates :user_id, presence: true, uniqueness: true
  validates :debate_teams_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :adjudicators_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :observers_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :debate_teams_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :debate_teams_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :fees, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  def grant_slots(debate_teams_granted, adjudicators_granted, observers_granted, fees=nil)
    #if nothing was set, we assume the granted values are not being set 
    if debate_teams_granted.blank? and adjudicators_granted.blank? and observers_granted.blank?
      self.debate_teams_granted = nil
      self.adjudicators_granted = nil
      self.observers_granted = nil
    else
      self.debate_teams_granted = debate_teams_granted.to_i
      self.adjudicators_granted = adjudicators_granted.to_i
      self.observers_granted = observers_granted.to_i

      if fees.blank?
        self.fees = (self.debate_teams_granted * BigDecimal.new(Setting.key('debate_team_fees')) +
          self.adjudicators_granted * BigDecimal.new(Setting.key('adjudicator_fees')) +
          self.observers_granted * BigDecimal.new(Setting.key('observer_fees')))
      else
        self.fees = fees
      end
    end
    self.save
  end

  def granted?
    (not self.debate_teams_granted.blank?) or (not self.adjudicators_granted.blank?) or (not self.observers_granted.blank?)
  end

  def total_confirmed_payments
    self.payments.inject(BigDecimal('0')) do |total, p|
      p.amount_received.nil? ? total : total + p.amount_received
    end
  end

  def total_unconfirmed_payments
    self.payments.inject(BigDecimal('0')) do |total,p|
      p.confirmed? ? total : total + p.amount_sent
    end
  end

  def balance_fees
    fees.nil? ? BigDecimal.new('0') : (fees - total_confirmed_payments)
  end

  def confirm_slots(debate_teams_confirmed=nil, adjudicators_confirmed=nil, observers_confirmed=nil)
    #if nothing was set, we assume the confirmed values are not being set 
    if debate_teams_confirmed.blank? and adjudicators_confirmed.blank? and observers_confirmed.blank?
      self.debate_teams_confirmed = nil
      self.adjudicators_confirmed = nil
      self.observers_confirmed = nil
    else
      self.debate_teams_confirmed = debate_teams_confirmed.to_i
      self.adjudicators_confirmed = adjudicators_confirmed.to_i
      self.observers_confirmed = observers_confirmed.to_i
    end
    self.save
  end

  def confirmed?
    (not self.debate_teams_confirmed.blank?) or (not self.adjudicators_confirmed.blank?) or (not self.observers_confirmed.blank?)
  end

end
