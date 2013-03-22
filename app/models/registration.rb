class Registration < ActiveRecord::Base
  strip_attributes

  belongs_to :team_manager, class_name: 'User'
  belongs_to :tournament
  belongs_to :institution

  has_many :payments, dependent: :destroy
  has_many :paypal_payments, dependent: :destroy
  has_many :manual_payments, dependent: :destroy

  has_many :debaters, dependent: :destroy
  has_many :adjudicators, dependent: :destroy
  has_many :observers, dependent: :destroy
  has_many :participants, dependent: :destroy

  accepts_nested_attributes_for :debaters
  accepts_nested_attributes_for :adjudicators
  accepts_nested_attributes_for :observers

  #added to allow for adding checkbox in activeadmin
  attr_accessor :override_fees
  attr_accessible :debate_teams_requested, :adjudicators_requested, :observers_requested, :debaters_attributes, :adjudicators_attributes, :observers_attributes

  validates :debate_teams_requested, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 50 }, allow_blank: true
  validates :adjudicators_requested, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 50 }, allow_blank: true
  validates :observers_requested, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 50 }, allow_blank: true
  validates :debate_teams_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_granted, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :debate_teams_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :adjudicators_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :observers_confirmed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :fees, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :institution_id, presence: true
  validates :institution_id, uniqueness: { scope: :tournament_id }
  validates :team_manager_id, presence: true
  validates :team_manager_id, uniqueness: { scope: :tournament_id }
  validates :tournament_id, presence: true

  def self.for_tournament(tournament_identifier, user)
    query = includes(:tournament).where('tournaments.identifier = ?', tournament_identifier)
    if user.is_a?(AdminUser)
      query = query.where('tournaments.admin_user_id = ?', user.id)
    else
      query = query.where('registrations.team_manager_id = ?', user.id)
    end
    query
  end

  def draft?
    ![requested_at,
     debate_teams_requested,
     adjudicators_requested,
     observers_requested].any?
  end


  def request_slots(dt_req, a_req, o_req)
    self.debate_teams_requested = dt_req.to_i
    self.adjudicators_requested = a_req.to_i
    self.observers_requested = o_req.to_i
    self.requested_at = Time.now
    self.save
  end

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
      if [self.debate_teams_granted_changed?, self.adjudicators_granted_changed?, self.observers_granted_changed?].any?
        RegistrationMailer.slots_granted_notification(self).deliver
      end
      if fees.blank?
        self.fees = (self.debate_teams_granted * BigDecimal.new(Setting.key(tournament, 'debate_team_fees') || 0) +
          self.adjudicators_granted * BigDecimal.new(Setting.key(tournament, 'adjudicator_fees') || 0) +
          self.observers_granted * BigDecimal.new(Setting.key(tournament, 'observer_fees') || 0))
      else
        self.fees = fees
      end
    end
    self.save
  end


  def requested?
    (not debate_teams_requested.blank?) or (not adjudicators_requested.blank?) or (not observers_requested.blank?)
  end

  def granted?
    (not debate_teams_granted.blank?) or (not adjudicators_granted.blank?) or (not observers_granted.blank?)
  end

  def total_confirmed_payments
    self.payments.confirmed.sum(:amount_received)
  end

  def total_unconfirmed_payments
    self.payments.unconfirmed.sum(:amount_sent)
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
      if [self.debate_teams_confirmed_changed?, self.adjudicators_confirmed_changed?, self.observers_confirmed_changed?].any?
        RegistrationMailer.slots_confirmed_notification(self).deliver
      end
    end
    self.save
  end

  def confirmed?
    (not self.debate_teams_confirmed.blank?) or (not self.adjudicators_confirmed.blank?) or (not self.observers_confirmed.blank?)
  end

  def debate_teams
    debate_teams = []
    self.debate_teams_confirmed.times {debate_teams << []}
    self.debaters.each do |debater|
      #if the team_number or speaker_number is empty we create a fresh debater record
      # this should only happen in tests as we always set the hidden values in the form
      debate_teams[debater.team_number-1][debater.speaker_number-1] = debater if debater.team_number.present? and debater.speaker_number.present?
    end

    (1..self.debate_teams_confirmed).each do |debate_team_number|
      (1..Setting.key(tournament, 'debate_team_size').to_i).each do |speaker_number|
        if debate_teams[debate_team_number - 1][speaker_number-1].nil?
          debate_teams[debate_team_number-1][speaker_number-1]  = self.debaters.build(team_number: debate_team_number, speaker_number: speaker_number)
        end
      end
    end

    return debate_teams
  end

  def institution_name
    self.institution.name
  end

  def paypal_recipients
    host_paypal_account = Setting.key(self.tournament,'host_paypal_account')
    raise 'Host paypal account setting not set' if host_paypal_account.nil?
    [{:email => host_paypal_account,
      :amount => self.balance_fees,
      :primary => true}, {
        :email => ::FASTREGO_PAYPAL_ACCOUNT,
        :amount => self.fastrego_fees_portion,
        :primary => false
      }
    ]
  end

  def fastrego_fees_portion
    self.balance_fees * 0.05
  end

  def host_fees_portion
    self.balance_fees * 0.95
  end

end
