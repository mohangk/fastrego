class Participant < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore
  CUSTOM_FIELDS = UadcRego::Application.config.custom_fields || []

  belongs_to :registration

	validates_presence_of :name, :gender, :email, :dietary_requirement, :emergency_contact_person, :emergency_contact_number, :registration

  #TODO: Figure out why after_initialize is not being called when Participant is a nested attribute
  after_initialize :setup_hstore
  
  CUSTOM_FIELDS.each do |attr_name|

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
 
  def setup_hstore
    self.data ||= {} 
  end

  def self.custom_fields
    CUSTOM_FIELDS
  end

end
