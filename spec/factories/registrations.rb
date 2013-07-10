FactoryGirl.define do

  factory :registration do
    association :team_manager, factory: :user
    association :tournament, factory: :tournament
    institution

    factory :requested_registration do
      debate_teams_requested 3
      adjudicators_requested 1
      observers_requested 1
      requested_at '2011-01-01 01:01:01'

      factory :granted_registration do
        debate_teams_granted 1
        fees 90

        factory :confirmed_registration do
          debate_teams_confirmed 1
          adjudicators_confirmed 1
          observers_confirmed 1

          factory :complete_registration do
            adjudicators { [FactoryGirl.create(:adjudicator)] }
            debaters { [FactoryGirl.create(:debater)] }
          end
        end
      end
    end

  end

end
