FactoryGirl.define do

  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@test.com" }
    password 'password'
  end

  factory :t2_admin_user, class: AdminUser do
    email 't2.admin@test.com'
    password 'password'
  end
end
