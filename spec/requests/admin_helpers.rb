module AdminHelpers
  def login
    FactoryGirl.create(:admin_user)
    visit admin_dashboard_path
    page.should have_content 'Login'
    fill_in 'Email', with: 'admin@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end
end
