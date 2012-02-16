class Registration < ActiveRecord::Base
  strip_attributes
  attr_accessible :debate_teams_requested, :adjudicators_requested, :observers_requested
  validates :user_id, presence: true, uniqueness: true
  belongs_to :user
  validates :debate_teams_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :adjudicators_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :observers_requested, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 7 }
  validates :debate_teams_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :debate_teams_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :fees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  def grant_slots(debate_teams_granted, adjudicators_granted, observers_granted, fees=nil)
    self.debate_teams_granted=debate_teams_granted
    self.adjudicators_granted=adjudicators_granted
    self.observers_granted=observers_granted
    if fees.blank?
      self.fees = (self.debate_teams_granted * Setting.key('debate_team_fees').to_i +
        self.adjudicators_granted * Setting.key('adjudicator_fees').to_i +
        self.observers_granted * Setting.key('observer_fees').to_i)
    else
      self.fees = fees
    end
    self.save
  end

  def granted?
    (not self.debate_teams_granted.blank?) or (not self.adjudicators_granted.blank?) or (not self.observers_granted.blank?)
  end
end
