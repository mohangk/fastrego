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
end