require 'spec_helper'

describe "Institutions" do
  describe "list" do

    it "provides a list of institutions", do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      mmu = FactoryGirl.create(:institution)
      visit institutions_path
      page.should have_content('Multimedia University')
      page.should have_content('MMU')
      page.should have_content('Malaysia')
      page.should have_content('http://www.mmu.edu.my')
      page.should_have_link('Add a team manager')
      page.should have_link 'Click here to add your institution now'
    end
  end

  describe "new" do
    it "provides a form that allows you to add a new institution and redirects upon success to the institutions list" do
      visit institutions_path
      click_link 'Click here to add your institution now'
      page.should have_content('New institution')
      fill_in 'Name', with: 'Universiti Teknologi Malaysia'
      fill_in 'Abbreviation', with: 'UTM'
      fill_in 'Website', with: 'http://www.utm.com'
      select('Malaysia', from: 'Country')
      click_button 'Save'
      page.should have_content('successfully registered')
      page.current_path.should == institutions_path
    end
  end



end
