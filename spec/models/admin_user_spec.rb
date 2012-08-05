require 'spec_helper'

describe AdminUser do
  it { should have_many(:tournaments) }
end
