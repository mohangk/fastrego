class DebateTeamDetails < GenericPage
  
  def correct_page?
    page.should have_css 'input[type="text"][name="registration[debaters_attributes][0][name]"]'
  end
  
  def fill_details options = {}, custom_fields = {}
    
    fill_in 'Name', with: options[:name] || 'Test Speaker'
    choose options[:gender] || 'Male'
    fill_in 'Email', with: options[:email] || 'speaker@utm.com'
    choose options[:dietary_requirements] || 'No_special_requirements'
    fill_in 'Emergency contact person', with: options[:emergency_contact_person] || 'Test Contact Person'
    fill_in 'Emergency contact number', with: options[:emergency_contact_number] || '1231234'
    fill_in 'Preferred roommate', with: options[:preferred_roommate] || 'Test roommate'
    fill_in 'Preferred roommate institution', with: options[:preferred_roommate_institution] || 'NUS'

    custom_fields.each do |k,v|
      fill_in k, with: v
    end

    click_button 'Update'

    page.should have_content('Debater profiles were updated')
    page.current_path.should == profile_path

    TournamentRegistration.new
  end
  
  def field_value field_name
    find_field(field_name).value
  end
  
end
