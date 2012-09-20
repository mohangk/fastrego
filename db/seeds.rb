#Assuming that there are at least 2 tournaments and 2 admin users already in the system

#Create users

uadc_user = User.find_or_initialize_by_email({:email => 'uadc@gmail.com', :name => 'Uadc user',  :password => 'password', :password_confirmation => 'password'})
uadc_user.skip_confirmation!
uadc_user.save!

mmuopen_user = User.find_or_initialize_by_email({:email => 'mmuopen@gmail.com',:name => 'Mmuopen user',  :password => 'password', :password_confirmation => 'password'})
mmuopen_user.skip_confirmation!
mmuopen_user.save!


#Create registrations

Registration.destroy_all

uadc_rego = Registration.new(debate_teams_requested: 1, adjudicators_requested: 2, observers_requested: 3)  
uadc_rego.team_manager = uadc_user
uadc_rego.tournament = Tournament.find_by_identifier('uadc')
uadc_rego.institution = Institution.first
uadc_rego.requested_at = Time.now
uadc_rego.save!

mmuopen_rego = Registration.new(debate_teams_requested: 4, adjudicators_requested: 5, observers_requested: 6)  
mmuopen_rego.team_manager = mmuopen_user
mmuopen_rego.tournament = Tournament.find_by_identifier('mmuopen')
mmuopen_rego.institution = Institution.first
mmuopen_rego.requested_at = Time.now
mmuopen_rego.save!
