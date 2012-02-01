require 'spec_helper'

describe "Institutions" do
  describe "list" do
    it "provides a list of institutions with a link to create a team manager or display the name of one if already exists", do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      mmu = FactoryGirl.create(:institution)
      visit institutions_path
      page.should have_content('Multimedia University')
      page.should have_content('MMU')
      page.should have_content('Malaysia')
      page.should have_content('http://www.mmu.edu.my')
      page.should have_css("a[href='/users/sign_up?institution_id=#{mmu.id}']")
      page.should have_link 'Click here to add your institution now'

      user = Factory(:user, institution: mmu)
      user.institution = mmu
      visit institutions_path

      page.should_not have_css("a[href='/users/sign_up?institution_id=#{mmu.id}']")
      page.should have_content('Suthen Thomas')

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
