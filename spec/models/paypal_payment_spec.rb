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
    it { generated.details.should == "Registration fees for #{registration.tournament.name}" }

    it 'sets the fastrego_fees to the calculatd_fastrego_fees' do
      generated.fastrego_fees.to_f.should == PaypalPayment.calculate_fastrego_fees(registration.balance_fees)
    end

    it 'sets the amount sent to balance_fees + calculated_fastrego_fees' do
      generated.amount_sent.to_f.should == registration.balance_fees + PaypalPayment.calculate_fastrego_fees(registration.balance_fees)
    end

    context 'pre_registration payment' do
      let(:generated) { PaypalPayment.generate registration, true }

      it { generated.details.should == "Pre registration fees for #{registration.tournament.name}" }

      it 'sets the amount sent to balance_pre_registration_fees + calculated_fastrego_fees' do
        generated.amount_sent.to_f.should == registration.balance_pre_registration_fees + PaypalPayment.calculate_fastrego_fees(registration.balance_pre_registration_fees)
      end

      it 'sets the fastrego_fees to the calculatd_fastrego_fees' do
        generated.fastrego_fees.to_f.should == PaypalPayment.calculate_fastrego_fees(registration.balance_pre_registration_fees)
      end
    end



    describe '#calculate_fastrego_fees' do

      it 'calculates the fees as 5%, rounded' do
        PaypalPayment.calculate_fastrego_fees(170.69).should == 8.53
        PaypalPayment.calculate_fastrego_fees(83).should == 4.15
      end

      it 'returns a minimum of 3' do
        PaypalPayment.calculate_fastrego_fees(20).should == 4
      end
    end

    describe 'registration_fees_in_cents * 100' do
      pending 'is the result of amount_sent - fastrego_fees' do

      end
    end




  end

end
