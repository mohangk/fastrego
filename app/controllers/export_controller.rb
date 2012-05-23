require 'csv'
class ExportController < ApplicationController
  def institution
    institution_csv = CSV.generate do |csv|
      # header row
      csv << ["code", "name"]

      # data rows
      Registration.all.each do |r|
        next unless r.confirmed? and (r.debate_teams_confirmed + r.adjudicators_confirmed + r.observers_confirmed > 0)
        csv << [r.user.institution.abbreviation, r.user.institution.name]
      end
    end
    send_data(institution_csv, :type => 'text/csv', :filename => 'institution.csv')
  end

  def adjudicator 
    adjudicator_csv = CSV.generate do |csv|
      # header row
      csv << ["institution-code", "name", "test_score", "active"]

      # data rows
      Registration.all.each do |r|
        next unless r.confirmed? &&  (r.debate_teams_confirmed + r.adjudicators_confirmed + r.observers_confirmed > 0)
        r.adjudicators.each do |a|
          csv << [r.user.institution.abbreviation, a.name, nil, nil]
        end
      end
    end
    send_data(adjudicator_csv, :type => 'text/csv', :filename => 'adjudicator.csv')
  end  
  
  def team 
    team_csv = CSV.generate do |csv|
      # header row
      csv << ["institution-code", "name", "active", "swing"]

      # data rows
      Registration.all.each do |r|
        next unless r.confirmed? &&  (r.debate_teams_confirmed  > 0)
        r.debate_teams_confirmed.times do |team_count|
          csv << [r.user.institution.abbreviation, 
                  "#{r.user.institution.abbreviation} #{team_count + 1}",
                  nil, nil]
        end
      end
    end
    send_data(team_csv, :type => 'text/csv', :filename => 'team.csv')
  end

  def debater 
    debater_csv = CSV.generate do |csv|
      # header row
      csv << ["team-name", "name"]

      # data rows
      Registration.all.each do |r|
        next unless r.confirmed? &&  (r.debate_teams_confirmed  > 0)
        r.debaters.each do |d|
          csv << [d.team_name, d.name]
        end
      end
    end
    send_data(debater_csv, :type => 'text/csv', :filename => 'debater.csv')
  end
end

