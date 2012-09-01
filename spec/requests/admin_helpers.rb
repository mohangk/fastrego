module AdminHelpers

  def set_subdomain(subdomain)
    host = "http://#{subdomain}.test.com"
    host! host
    #Capybara.app_host = host  
    Capybara.default_host = host
  end

  def login_for_tournament(tournament)
    set_subdomain(tournament.identifier)
    login(tournament.admin_user.email, t1.admin_user.password) 
  end

  def login email = 'admin@test.com', password = 'password'
    #FactoryGirl.create(:admin_user)
    visit admin_dashboard_path
    page.should have_content 'Login'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end
end
