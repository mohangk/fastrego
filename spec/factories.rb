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

  factory :debate_team_fees, :class => Setting do
    key 'debate_team_fees'
    value '200'
  end

  factory :adjudicator_fees, :class => Setting do
    key 'adjudicator_fees'
    value '100'
  end

  factory :observer_fees, :class => Setting do
    key 'observer_fees'
    value '100'
  end

  factory :enable_pre_registration, :class => Setting do
    key 'enable_pre_registration'
    value 'True'
  end

  factory :debate_team_size, class: Setting do
    key 'debate_team_size'
    value 3
  end

  factory :registration do
    debate_teams_requested 3
    adjudicators_requested 1
    observers_requested 1
    requested_at '2011-01-01 01:01:01'
    user
  end

  factory :payment do
    account_number 'AB1231234'
    amount_sent 12000
    date_sent '2011-12-12'
    comments 'Total payment - arriba!'
    scanned_proof { Rack::Test::UploadedFile.new(File.join(Rails.root,'spec','uploaded_files','test_image.jpg'), 'image/png')  }
    registration
  end

  factory :debater do
    name 'Jack Nostrum'
    gender 'Male'
    email 'test@test.com'
    dietary_requirement 'Normal'
    airport 'KLIA'
    emergency_contact_person 'Jason Statham'
    emergency_contact_number '123123123123'
    speaker_number 1
    team_number 1
    registration
  end
end