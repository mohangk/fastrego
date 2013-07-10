require 'forwardable'
require 'zip/zip'
require 'csv'

class ThreeTabExport

  attr_accessor :tournament, :exporters

  def initialize(tournament, exporters)
    self.exporters = exporters
    self.tournament = tournament
  end

  def self.generate_zip(tournament)
    exporters = self.new(tournament, [Institution.new, Adjudicator.new, Team.new, Debater.new]).export

    stringio = Zip::ZipOutputStream::write_buffer do |zio|
      exporters.each do |exporter|
        zio.put_next_entry(exporter.filename)
        zio.write exporter.string
      end
    end

    stringio.rewind
    stringio.sysread
  end

  def exportable?(r)
    r.confirmed? and (r.debate_teams_confirmed + r.adjudicators_confirmed + r.observers_confirmed > 0)
  end

  def export
    Registration.where(tournament_id: tournament.id).all.each do |r|
      exporters.each {|e| e.each_registration(r) } if exportable?(r)
    end
    exporters
  end

  class CsvFile
    extend Forwardable

    def_delegators :@csv, :string

    def initialize
      @buffer = StringIO.new
      @csv = ::CSV.new @buffer
      @csv << self.class.headers
    end

    def to_s
     @buffer.string
    end

    def filename
      "#{self.class.to_s.split('::').last.downcase}.csv"
    end

    def each_registration r
    end

    def self.headers
    end

  end

  class Institution < CsvFile

    def self.headers
      ["code", "name"]
    end

    def each_registration r
      @csv << [r.institution.abbreviation, r.institution.name]
    end

  end

  class Adjudicator < CsvFile

    def self.headers
      ["institution-code", "name", "test_score", "active"]
    end

    def each_registration r
      r.adjudicators.each do |a|
        @csv << [r.institution.abbreviation, a.name, nil, nil]
      end
    end
  end


  class Team < CsvFile

    def self.headers
      ["institution-code", "name", "active", "swing"]
    end

    def each_registration r
      r.debate_teams_confirmed.times do |team_count|
        @csv << [r.institution.abbreviation,
                "#{r.institution.abbreviation} #{team_count + 1}",
                nil, nil]
      end
    end
  end

  class Debater < CsvFile

    def self.headers
      ["team-name", "name"]
    end

    def each_registration r
      r.debaters.each do |d|
        @csv << [d.team_name, d.name]
      end
    end

  end

end
