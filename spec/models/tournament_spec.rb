require 'spec_helper'

describe Tournament do

 subject { FactoryGirl.create(:t1_tournament) }
 it { should belong_to(:admin_user) }
 it { should validate_presence_of(:name) }
 it { should validate_presence_of(:identifier) }
 it { should validate_uniqueness_of :identifier }
 it { should have_many(:settings) }
 it { should have_many(:registrations) }

 describe '#to_convertible_currency' do
   let(:tournament) { FactoryGirl.create :t1_tournament }

   before do
     tournament.stub(:paypal_currency_conversion?).and_return(true)
     tournament.stub(:currency_symbol).and_return('RM')
     tournament.stub(:paypal_currency).and_return('USD')
     tournament.stub(:paypal_conversion_rate).and_return(0.337)
     ConvertibleMoney.should_receive(:new).with('RM', 2000, { conversion_currency: 'USD', conversion_rate: 0.337 } )
   end

   it 'passes in the right values to ConvertibleMoney' do
     tournament.to_convertible_currency 2000
   end
 end
end
