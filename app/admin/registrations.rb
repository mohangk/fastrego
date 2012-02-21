ActiveAdmin.register Registration do

  config.sort_order = "requested_at_asc"

  index do
    column 'Req at', sortable: :requested_at do |r|
      r.requested_at.strftime("%d/%m %H:%M:%S")
    end
    column 'Inst' do |r|
        link_to r.user.institution.abbreviation, admin_institution_path(r.user.institution)
    end
    column 'DT Rq', :debate_teams_requested
    column 'Adj Rq', :adjudicators_requested
    column 'Obs Rq', :observers_requested
    column 'DT Gt', :debate_teams_granted
    column 'Adj Gt', :adjudicators_granted
    column 'Obs Gt', :observers_granted
    column 'DT Cnf', :debate_teams_confirmed
    column 'Adj Cnf', :adjudicators_confirmed
    column 'Obs Cnf', :observers_confirmed
    column :fees
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :user, :input_html => { :disabled => true }
      f.input :requested_at, :input_html => { :disabled => true }
      f.input :debate_teams_requested, :input_html => { :disabled => true }
      f.input :adjudicators_requested, :input_html => { :disabled => true }
      f.input :observers_requested, :input_html => { :disabled => true }
      f.input :debate_teams_granted
      f.input :adjudicators_granted
      f.input :observers_granted
      f.input :debate_teams_confirmed
      f.input :adjudicators_confirmed
      f.input :observers_confirmed
      f.input :fees
      f.buttons
    end
  end

  controller do
    def update
      @registration = Registration.find(params[:id])

      if @registration.grant_slots(params[:registration][:debate_teams_granted],
                                   params[:registration][:adjudicators_granted],
                                   params[:registration][:observers_granted],
                                   params[:registration][:fees])
        redirect_to admin_registrations_path, notice: 'Registration was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

end
