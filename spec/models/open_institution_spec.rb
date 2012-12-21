require 'spec_helper'

describe OpenInstitution do
  it { should belong_to :tournament }
  it { should validate_presence_of :tournament }
end
