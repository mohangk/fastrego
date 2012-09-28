module SubdomainLoginHelpers

  def set_subdomain(subdomain)
    host = "http://#{subdomain}.test.com"
    if example.metadata[:js]
      Capybara.server_port = 9988
      port = ':'+Capybara.server_port.to_s
      host = host+port
    end
    host! host
    Capybara.app_host = host  
    Capybara.default_host = host
  end

  def login_for_tournament(tournament)
    set_subdomain(tournament.identifier)
    login(tournament.admin_user.email, t1.admin_user.password) 
  end

  def login email = 'admin@test.com', password = 'password'
    visit admin_dashboard_path
    page.should have_content 'Login'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  def user_login email, password
    visit profile_path
    page.should have_content 'Sign in'
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Sign in'
  end 
end
