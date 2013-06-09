require 'spec_helper'

describe ConvertibleMoney do
  let(:amount) { BigDecimal('999.48') }
  let(:options) {{conversion_rate: BigDecimal('0.3337'), conversion_currency: 'USD'}}
  let(:money) { ConvertibleMoney.new('MYR', amount, options)}
  it { money.amount.to_s.should ==  amount.to_s }
  it { money.currency == 'MYR' }
  it { money.conversion_rate.to_s.should == '0.3337'}
  it { money.currency.should == 'MYR'}

  context 'when amount is nil' do
    let(:amount) { nil }
    it { money.amount.to_s.should == '0.0' }
  end

  describe '#conversion_amount' do

    it 'converts the amount' do
      money.conversion_amount.to_s.should == '333.53'
    end

    context 'when there is nothing to convert' do
      let(:options) {}
      it 'returns the original amount' do
        money.conversion_amount.to_s.should == '999.48'
      end
    end
  end

  describe '#conversion_currency' do
    it 'returns the conversion_currency symbol' do
      money.conversion_currency.should == 'USD'
    end

    context 'when there is nothing to convert' do
      let(:options) {}
      it 'returns the original currency' do
        money.conversion_currency.should == 'MYR'
      end
    end
  end

  describe 'artihmetic' do
    it 'delegates all artihmetic operations' do
      (money - 1).to_s.should == '998.48'
      (money + 0.53).to_s.should == '1000.01'
    end
  end
end
