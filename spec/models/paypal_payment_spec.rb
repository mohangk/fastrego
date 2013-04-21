require 'spec_helper'

describe PaypalPayment do

  subject(:paypal_payment) { FactoryGirl.create(:paypal_payment) }

  its(:status) { should === 'Draft' }

  it { should validate_presence_of(:status) }

  describe '.generate' do
    let(:generated) { PaypalPayment.generate registration }

    let(:registration) do
      registration = FactoryGirl.build_stubbed :granted_registration
      registration.stub(balance_pre_registration_fees: 100,
             balance_fees: 900)
      registration
    end

    it { should be_a(PaypalPayment) }
    it { generated.status.should == PaypalPayment::STATUS_DRAFT }
    it { generated.registration.should == registration }
    it { generated.amount_sent.to_i.should == registration.balance_fees }

    context 'pre_registration payment' do
      let(:generated) { PaypalPayment.generate registration, true }

      it { generated.amount_sent.to_i.should == registration.balance_pre_registration_fees }

    end


  end

end
