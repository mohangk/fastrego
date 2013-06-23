ActiveAdmin.register MassEmail do
  menu false
  actions :new, :create

  form do |f|
    f.inputs "Send email to all team managers" do
      f.input :subject, as: :string
      f.input :from, as: :string, input_html: { disabled: true }
      f.input :content, as: :text
    end
    f.actions do
      f.action :submit, label: 'Send emails'
      f.action :cancel, label: 'Cancel'
    end
  end

  controller do

    def new
      if current_tournament.mass_emailing_enabled?
        @resource = MassEmail.new
        @resource.from = current_tournament.registration_email
        super
      else
        render 'admin/shared/paid_feature', layout: 'active_admin', locals: { feature_name: 'Mass emailing team managers' }
      end
    end

    def create
      mass_email = MassEmail.new(params[:mass_email])
      mass_email.from = current_tournament.registration_email
      if mass_email.valid? and current_tournament.mass_emailing_enabled?
        users = User.team_managers(current_subdomain, current_admin_user)
        SendMassEmail.new(users, mass_email.subject, mass_email.content, mass_email.from)
        redirect_to admin_registrations_path, notice: 'Sent email to team managers'
      end
    end

  end

end
