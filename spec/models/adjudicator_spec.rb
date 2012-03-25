require 'spec_helper'

describe Adjudicator do
  it { should belong_to :registration }
  it { should validate_presence_of :registration }
end