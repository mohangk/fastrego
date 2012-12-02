class Participant < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
  CUSTOM_FIELDS = UadcRego::Application.config.custom_fields || []

  belongs_to :registration

	validates_presence_of :name, :gender, :email, :dietary_requirement, :emergency_contact_person, :emergency_contact_number, :registration, :registration_id
  validates_uniqueness_of :email

  #TODO: Figure out why after_initialize is not being called when Participant is a nested attribute

  after_initialize :setup_hstore, :setup_custom_fields
  after_create :setup_custom_fields

  def setup_custom_fields
    return if registration.nil?
    tournament_identifier = registration.tournament.identifier
    Participant.class_eval do
      CUSTOM_FIELDS[tournament_identifier].each do |attr_name|
        define_method "#{attr_name}=" do |attr_value|
          setup_hstore
          self.send(:attribute_will_change!, 'data')
          self.data[attr_name] = attr_value
        end

        define_method attr_name do 
          setup_hstore
          self.data[attr_name].nil? ? nil :  self.data[attr_name]
        end
      end  
    end
  end

  def respond_to? method, include_private=false  
    if not registration.nil?
      tournament_identifier = registration.tournament.identifier
      attrib = (method =~ /=$/) ? method[0..-2] : method
      return true if CUSTOM_FIELDS[tournament_identifier].include?(attrib)
    end
    super
  end
  def setup_hstore
    self.data ||= {} 
  end

  def custom_fields
    CUSTOM_FIELDS[registration.tournament.identifier] || []
  end

  def self.custom_fields tournament_identifier
    CUSTOM_FIELDS[tournament_identifier] || []
  end

end
