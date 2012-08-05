require 'spec_helper'

describe Tournament do
 it { should belong_to(:admin_user) }
 it { should have_many(:settings) }
 it { should have_many(:registrations) }
end
