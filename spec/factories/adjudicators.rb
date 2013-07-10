FactoryGirl.define do
  factory :adjudicator do
    name 'Jack Nostrum'
    gender 'Male'
    sequence(:email) { |n| "test_adjudicator#{n}@test.com" }
    dietary_requirement 'Halal'
    point_of_entry 'KLIA'
    emergency_contact_person 'Jason Statham'
    emergency_contact_number '123123123123'
    registration
  end
end
