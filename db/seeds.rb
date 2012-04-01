# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Setting.create(
	[
		{key: 'enable_pre_registration', value: 'False' },
		{key: 'observer_fees', value: '100'},
		{key: 'adjudicator_fees', value: '100'},
		{key: 'debate_team_fees', value: '200'},
		{key: 'debate_team_size', value: '3'}
	])
