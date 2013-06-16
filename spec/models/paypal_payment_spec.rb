require 'spec_helper'

describe PaypalPayment do

  subject(:paypal_payment) { FactoryGirl.create(:paypal_payment,
                                               amount_sent: 50,
                                               currency: 'INR',
                                               conversion_currency: 'RM',
                                               amount_received: 50,
                                               conversion_rate: '0.1',
                                               fastrego_fees: 5)
  }

  its(:status) { should === 'Draft' }

  it { should validate_presence_of(:status) }

  describe '.generate' do

    before :each do
      PaypalPayment.stub(:calculate_fastrego_fees).and_return(999.99)
    end

    let(:generated) { PaypalPayment.generate registration }

    let(:balance_pre_registration_fees) { ConvertibleMoney.new('INR', 100, {conversion_rate: BigDecimal.new('0.337'), conversion_currency: 'USD'}) }
    let(:balance_fees) { ConvertibleMoney.new('INR', 900, {conversion_rate: BigDecimal.new('0.337'), conversion_currency: 'USD'}) }

    let(:registration) do
      registration = FactoryGirl.build_stubbed :granted_registration
      registration.stub(balance_pre_registration_fees: balance_pre_registration_fees,
                        balance_fees: balance_fees )
      registration
    end

    it { should be_a(PaypalPayment) }
    it { should be_persisted }
    it { generated.status.should == PaypalPayment::STATUS_DRAFT }
    it { generated.registration.should == registration }
    it { generated.details.should == "Registration fees for #{registration.tournament.name}" }
    it { generated.conversion_currency.should == balance_fees.conversion_currency }
    it { generated.conversion_rate.should == balance_fees.conversion_rate }
    it { generated.currency.should == balance_fees.currency }

    it 'sets the fastrego_fees based on the result of PaypalPayment.calculate_fastrego_fees' do
      PaypalPayment.should_receive(:calculate_fastrego_fees).with(registration.balance_fees).and_return(999.99)
      generated.fastrego_fees.should == 999.99
    end

    it 'sets the amount sent to balance_fees + calculated_fastrego_fees' do
      generated.amount_sent.to_d.should == registration.balance_fees + 999.99
    end

    context 'pre_registration payment' do
      let(:generated) { PaypalPayment.generate registration, true }

      it { generated.details.should == "Pre registration fees for #{registration.tournament.name}" }

      it 'sets the amount sent to balance_pre_registration_fees + calculated_fastrego_fees' do
        generated.amount_sent.should == registration.balance_pre_registration_fees + 999.99
      end

      it 'sets the fastrego_fees to the calculatd_fastrego_fees' do
        PaypalPayment.should_receive(:calculate_fastrego_fees).with(registration.balance_pre_registration_fees).and_return(999.99)
        generated.fastrego_fees.should == 999.99
      end
    end
  end

  describe '.calculate_fastrego_fees' do

    it 'calculates the fees as 5%, rounded and return it in the base currency' do
      fees = double(conversion_rate: 0.1, conversion_amount: 170.69)
      PaypalPayment.calculate_fastrego_fees(fees).should == 85.30
      fees = double(conversion_rate: 0.1, conversion_amount: 83)
      PaypalPayment.calculate_fastrego_fees(fees).should == 41.50
    end

    it 'returns a minimum of 4' do
      fees = double(conversion_rate: 0.1, conversion_amount: 20)
      PaypalPayment.calculate_fastrego_fees(fees).should == 40
    end
  end

  describe '#registration_fees' do
    before do
      paypal_payment.stub(:amount_sent).and_return(BigDecimal.new('50.0'))
      paypal_payment.stub(:fastrego_fees).and_return(BigDecimal.new('5.0'))
    end

    it 'returns amount_sent - fastrego_fees' do
      paypal_payment.registration_fees.should == BigDecimal.new('45.0')
    end

    context 'when amount_sent is not set' do

      before do
        paypal_payment.stub(:amount_sent).and_return(nil)
      end

      it 'returns 0' do
        paypal_payment.registration_fees.should == 0
      end
    end

    context 'when fastrego_fees is not set' do

      before do
        paypal_payment.stub(:fastrego_fees).and_return(nil)
      end

      it 'returns the amount_sent' do
        paypal_payment.registration_fees.should == 50.0
      end
    end
  end

  describe '#update_pay_key' do
    it {
      paypal_payment.update_pay_key('FakePayKey')
      paypal_payment.status.should == PaypalPayment::STATUS_PENDING
      paypal_payment.transaction_txnid.should == 'FakePayKey'
    }
  end

  describe '#regisration_fees_as_convertible_money' do


    it 'returns a convertible money' do
      paypal_payment.registration_fees_as_convertible_money.should be_a(ConvertibleMoney)
    end

    it 'sets up ConvertibleMoney right' do
      ConvertibleMoney.should_receive(:new).with(paypal_payment.currency,
                                                 paypal_payment.registration_fees,
                                                 {
                                                   conversion_rate: paypal_payment.conversion_rate,
                                                   conversion_currency: paypal_payment.conversion_currency,
                                                 })
      paypal_payment.registration_fees_as_convertible_money
    end
  end

  describe '#fastrego_fees_as_convertible_money' do

    it 'returns a convertible money' do
      paypal_payment.fastrego_fees_as_convertible_money.should be_a(ConvertibleMoney)
    end

    it 'sets up ConvertibleMoney right' do
      ConvertibleMoney.should_receive(:new).with(paypal_payment.currency,
                                                 paypal_payment.fastrego_fees,
                                                 {
                                                   conversion_rate: paypal_payment.conversion_rate,
                                                   conversion_currency: paypal_payment.conversion_currency,
                                                 })
      paypal_payment.fastrego_fees_as_convertible_money
    end

  end
end
