require 'spec_helper'

describe 'AdminSettinngs' do

  describe 'settings associated with this admin_user and the subdomains' do

    let!(:t2) { FactoryGirl.create(:t2_tournament) }
    let!(:t1) { FactoryGirl.create(:t1_tournament) }
    let!(:t2_setting) { FactoryGirl.create(:tournament_name, tournament: t2) }
    let!(:t1_setting) { FactoryGirl.create(:tournament_name, value: 'T1 tournament', tournament: t1) }
     
    it 'can be listed and edited' do
      login_for_tournament(t2)
      visit admin_settings_path

      page.should have_content 'Settings'
      page.should have_content t2_setting.value
      page.should_not have_content t1_setting.value

      page.should_not have_content 'New'
      page.should have_content 'Edit'
      page.should_not have_content 'Delete'
      
      click_link 'Edit'

      page.should_not have_field('Key')
      fill_in 'Value', with: 'New value'
      click_button 'Update Setting'

      page.should_not have_content t2_setting.key
      page.should_not have_content t2_setting.value
      page.should have_content 'New value'
      page.should have_content 'Key'
  
    end
  end
  it 'allows the creation of setting without exposing the tournament in the form'
end

