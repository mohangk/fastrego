FactoryGirl.define do
  factory :institution do
    abbreviation 'MMU'
    name 'Multimedia University'
    website 'http://www.mmu.edu.my'
    country 'Malaysia'
  end

  factory :user do
    name 'Suthen Thomas'
    email 'suthen.thomas@gmail.com'
    password 'password'
    phone_number '123123123123'
    institution
  end

  factory :enable_pre_registration, :class => Setting do
    key 'enable_pre_registration'
    value 'True'
  end

  factory :registration do
    debate_teams_requested 3
    adjudicators_requested 1
    observers_requested 1
    requested_at '2011-01-01 01:01:01'
    user
  end
end