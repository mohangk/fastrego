class Participant < ActiveRecord::Base
  belongs_to :registration
	validates_presence_of :name, :gender, :email, :dietary_requirement, :emergency_contact_person, :emergency_contact_number, :registration

  after_initialize :setup_hstore
  
  def setup_hstore
    self.data ||= {} 
  end
  
  def tshirt_size 
    self.data['tshirt_size'].nil? ? nil :  self.data['tshirt_size'].to_i
  end

  def tshirt_size=(tshirt_size)
    self.send(:attribute_will_change!, 'data')
    self.data['tshirt_size'] = tshirt_size
  end
 
  def debate_experience
    self.data['debate_experience'].nil? ? nil :  self.data['debate_experience'].to_i
  end

  def debate_experience=(debate_experience)
    self.send(:attribute_will_change!,'data')
    self.data['debate_experience'] = debate_experience
  end

 end
