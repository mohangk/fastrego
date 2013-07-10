FactoryGirl.define do

  factory :user do
      after(:build) { |user| user.skip_confirmation! }
      name 'Suthen Thomas'
      sequence(:email) { |n| "suthen#{n}.thomas@gmail.com" }
      password 'password'
      phone_number '123123123123'
  end

  factory :tournament_name, class: Setting do
    key 'tournament_name'
    value 'Logan\'s Debate Extravaganza'
    association :tournament, factory: :t1_tournament

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

    factory :pre_registration_fees_percentage, :class => Setting do
      key Setting::PRE_REGISTRATION_FEES_PERCENTAGE
      value '50'
    end

    factory :tournament_registration_email, :class => Setting do
      key Setting::TOURNAMENT_REGISTRATION_EMAIL
      value 'test@test.com'
    end

    factory :enable_paypal_payment, :class => Setting do
      key Setting::ENABLE_PAYPAL_PAYMENT
      value 'True'
    end

    factory :debate_team_size, class: Setting do
      key 'debate_team_size'
      value 3
    end

    factory :currency_symbol, :class => Setting do
      key 'currency_symbol'
      value 'RM'
    end

    factory :host_paypal_login, class: Setting do
      key Setting::HOST_PAYPAL_LOGIN
      value 'mohang_1356050668_biz@gmail.com'
    end

    factory :host_paypal_password, class: Setting do
      key Setting::HOST_PAYPAL_PASSWORD
      value 'password'
    end
    factory :host_paypal_signature, class: Setting do
      key Setting::HOST_PAYPAL_SIGNATURE
      value 'signature'
    end
  end


  factory :manual_payment do
    account_number 'AB1231234'
    amount_sent 12000
    date_sent '2011-12-12'
    comments 'Total payment - arriba!'
    scanned_proof { Rack::Test::UploadedFile.new(File.join(Rails.root,'spec','uploaded_files','test_image.jpg'), 'image/png')  }
    registration

    factory :completed_manual_payment do
      amount_received 12000
      admin_comment 'This is an admin comment'
    end
  end

  factory :paypal_payment do
    account_number 'test_account@gmail.com'
    amount_sent 50
    status 'Draft'
    transaction_txnid 'fakeid123'
    registration
  end

  factory :observer, class: Observer do
    name 'Jack Observer'
    gender 'Male'
    sequence(:email) { |n| "test_observer#{n}@test.com" }
    dietary_requirement 'Halal'
    point_of_entry 'KLIA'
    emergency_contact_person 'Jason Statham'
    emergency_contact_number '123123123123'
    registration

    factory :custom_field_observer do
      debate_experience 5
      tshirt_size 'small'
    end
  end


  factory :debater do
    name 'Jack Nostrum'
    gender 'Male'
    sequence(:email) { |n| "test_debater#{n}@test.com" }
    dietary_requirement 'Halal'
    point_of_entry 'KLIA'
    emergency_contact_person 'Jason Statham'
    emergency_contact_number '123123123123'
    speaker_number 1
    team_number 1
    registration
  end

end
