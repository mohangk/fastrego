require 'ostruct'
class Enquiry  < OpenStruct
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  validates_presence_of :name, :email, :country, :institution, :tournament, :tournament_description, :tournament_type, :expected_teams, :expected_adjudicators

  def self.reflect_on_association(assoc)
    nil
  end

  def persisted?
    false
  end
end
