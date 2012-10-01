describe "Login" do

  let!(:t1) { FactoryGirl.create(:t1_tournament) } 

  before(:each) do
    set_subdomain t1.identifier
  end

  it 'has a sign up form' do
    visit profile_path
    click_link 'Sign up'
    page.should have_content 'Sign up'
  end

  it 'has a recover password form' do
    visit profile_path
    click_link 'Forgot your password?'
    page.should have_content 'Forgot your password?'
  end

  it 'has a recover password form' do
    visit profile_path
    click_link "Didn't receive confirmation instructions?"
    page.should have_content "Resend confirmation instructions"
  end
 
  pending 'it raises a 404 when tryign to access a subdomain that does not exist'
  pending 'shares logins between tournaments'
end
