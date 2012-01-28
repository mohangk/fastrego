FactoryGirl.define do
  factory :institution do
    abbreviation 'MMU'
    name 'Multimedia University'
    website 'http://www.mmu.edu.my'
    country 'Malaysia'
  end

  factory :user do
    name 'Suthen Thoma'
    email 'suthen.thomas@gmail.com'
    password 'password'
    phone_number '123123123123'
    institution
  end
end