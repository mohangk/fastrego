FactoryGirl.define do
  factory :t1_tournament, class: Tournament do
    name 'tournament 1'
    active true
    identifier 't1'
    admin_user
  end

  factory :t2_tournament, class: Tournament do
    name 'tournament 2'
    active true
    identifier 't2'
    association :admin_user, factory: :admin_user
  end

  factory :tournament do
    sequence(:name) { |n| "Tournament {n}" }
    active true
    sequence(:identifier) { |n| "tournament#{n}" }
    association :admin_user, factory: :admin_user
  end
end
