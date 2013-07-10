FactoryGirl.define do
  factory :institution do
    sequence(:abbreviation) { |n| "MMU#{n}" }
    sequence(:name) { |n| "Multimedia University #{n}" }
    type 'University'
    website 'http://www.mmu.edu.my'
    country 'Malaysia'
  end

  factory :university do
    sequence(:abbreviation) { |n| "MMU#{n}" }
    sequence(:name) { |n| "Multimedia University #{n}" }
    website 'http://www.mmu.edu.my'
    country 'Malaysia'
  end

  factory :open_institution, class: OpenInstitution do
    sequence(:abbreviation) { |n| "MMU#{n}" }
    sequence(:name) { |n| "Multimedia University #{n}" }
    website 'http://www.mmu.edu.my'
    country 'Malaysia'
    association :tournament, factory: :t1_tournament
  end

end
