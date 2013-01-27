require 'spec_helper'

describe PaypalPayment do

  subject(:paypal_payment) { FactoryGirl.create(:paypal_payment) }

  its(:status) { should === 'Draft' }

  it { should validate_presence_of(:status) }

end
