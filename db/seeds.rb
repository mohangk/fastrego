#Setup all required configuration options
Setting.create(
	[
		{key: 'enable_pre_registration', value: 'False' },
		{key: 'observer_fees', value: '100'},
		{key: 'adjudicator_fees', value: '100'},
		{key: 'debate_team_fees', value: '200'},
		{key: 'debate_team_size', value: '3'}
	])

#Setup default admin user
#AdminUser.create!(:email => 'test@gmail.com', :password => 'password', :password_confirmation => 'password')