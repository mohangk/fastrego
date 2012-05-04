class AddRegistrationEmailToSettings < ActiveRecord::Migration
  def change
    registration_email = case ENV['production_hostname']
          when 'uadc2012.herokuapp.com'
            'registration@mmuuadc2012.org'
          when 'wudcberlin.herokuapp.com'
            'info@wudcberlin.com'
          when 'bipedsabp.herokuapp.com'
            'bipedsabp.regist@yahoo.com'
          else
            'set.your.tournament.email.here@test.com'
        end
    Setting.key('tournament_registration_email', registration_email)
  end
end
