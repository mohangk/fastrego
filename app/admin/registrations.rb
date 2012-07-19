ActiveAdmin.register Registration do
  scope :all, :default => true do |r|
    r.includes [ :user => :institution ]
  end
  
  config.sort_order = "requested_at_asc"

  index do
    column 'Req at', sortable: :requested_at do |r|
      r.requested_at.strftime("%d/%m %H:%M:%S")
    end
    column 'Inst',sortable: 'institutions.abbreviation' do |r|
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
    column 'Fees', :fees
    column 'Unconf', :total_unconfirmed_payments, sortable: false
    column 'Conf', :total_confirmed_payments, sortable: false
    column 'Bal', :balance_fees, sortable: false
    default_actions
  end

  csv do
    column('Req at') do |r|
      r.requested_at.strftime("%d/%m %H:%M:%S")
    end
    column('Inst name') do |r|
      r.user.institution.name
    end
    column('Inst abbr') do |r|
      r.user.institution.abbreviation
    end
    column('Email') do |r|
      r.user.email
    end
    column('TM name') do |r|
      r.user.name
    end
    column('DT Rq') { |r| r.debate_teams_requested }
    column('Adj Rq') { |r| r.adjudicators_requested }
    column('Obs Rq') { |r| r.observers_requested }
    column('DT Gt') { |r| r.debate_teams_granted }
    column('Adj Gt') { |r| r.adjudicators_granted }
    column('Obs Gt') { |r| r.observers_granted }
    column('DT Cnf') { |r| r.debate_teams_confirmed }
    column('Adj Cnf') { |r| r.adjudicators_confirmed }
    column('Obs Cnf') { |r| r.observers_confirmed }
    column :fees
    column('Unconf') { |r| r.total_unconfirmed_payments }
    column('Conf') { |r| r.total_confirmed_payments }
    column('Bal') { |r| r.balance_fees }
  end

  form do |f|
    if f.object.new_record? and f.object.requested_at.nil?
      f.object.requested_at = Time.now
    elsif not f.object.new_record?
      disable_field = true 
    end
    f.inputs 'Request details' do
      f.input :user, label: 'Team manager', as: :select, collection: Hash[User.order(:name).all.map{ |u| [u.name, u.id] }], :input_html => { :disabled => disable_field }
      f.input :requested_at, as: :datetime, include_seconds: true, :input_html => {  :disabled => disable_field , :include_seconds => true}
      f.input :debate_teams_requested, :input_html => { :disabled => disable_field }
      f.input :adjudicators_requested, :input_html => { :disabled => disable_field }
      f.input :observers_requested, :input_html => { :disabled => disable_field }
    end

    f.inputs 'Grant slots' do
      f.input :debate_teams_granted
      f.input :adjudicators_granted
      f.input :observers_granted
    end

    f.inputs 'Override system computed fees' do
      f.input :override_fees, as: :boolean,
              label: 'Select this checkbox if you want to provide a different fee than the system generated fee',
              input_html: { onclick: "$('#registration_override_fees').is(':checked') ? $('#registration_fees').removeAttr('disabled') :$('#registration_fees').attr('disabled','disabled');" }
      f.input :fees, :input_html => { :disabled => true }
    end

    f.inputs 'Confirmed slots' do
      f.input :debate_teams_confirmed
      f.input :adjudicators_confirmed
      f.input :observers_confirmed
    end
    f.buttons
  end

  controller do
    def create
      r =  params[:registration]
      @registration = Registration.new(r)
      @registration.user_id = r[:user_id]
      requested_at = Time.local(r[:'requested_at(1i)'], r[:'requested_at(2i)'],r[:'requested_at(3i)'], r[:'requested_at(4i)'], r[:'requested_at(5i)'], r[:'requested_at(6i)'])
      @registration.requested_at = requested_at
      if @registration.save and grant_and_confirm(@registration)
        redirect_to admin_registrations_path, notice: 'Registration was successfully created'
      else 
        render action: "edit"
      end
    end

    def grant_and_confirm(registration)
      return registration.grant_slots(params[:registration][:debate_teams_granted],
                                   params[:registration][:adjudicators_granted],
                                   params[:registration][:observers_granted],
                                   params[:registration][:fees]) && registration.confirm_slots(params[:registration][:debate_teams_confirmed],
                                   params[:registration][:adjudicators_confirmed],
                                   params[:registration][:observers_confirmed])
    end

    def update
      @registration = Registration.find(params[:id])
      if grant_and_confirm(@registration)
        redirect_to admin_registrations_path, notice: 'Registration was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

  filter :user_id, collection: proc { Hash[User.order(:name).all.map{ |u| [u.name, u.id] }] }
  filter :user_institution_name, as: :select, collection: proc { Institution.order(:name).all.map(&:name) }
  filter :requested_at
  filter :fees
  filter :debate_teams_requested
  filter :adjudicators_requested
  filter :observers_requested
  filter :debate_teams_granted
  filter :adjudicators_granted
  filter :observers_granted
  filter :debate_teams_confirmed
  filter :adjudicators_confirmed
  filter :observers_confirmed
end
