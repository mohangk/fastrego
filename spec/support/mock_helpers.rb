require 'ostruct'

module MockHelperMethods

  @@pre_registration_enabled = false

  def current_tournament 
    OpenStruct.new(currency_symbol: 'RM', pre_registration_enabled?: @@pre_registration_enabled, name: 'MMU Worlds')
  end

  def self.set_pre_registration_enabled(enabled)
    @@pre_registration_enabled = enabled
  end

end
