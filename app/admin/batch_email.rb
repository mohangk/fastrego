ActiveAdmin.register BatchEmail do
  menu false
  actions :new, :create

  form do |f|
    f.inputs "Send email to all team managers" do
      f.input :subject, as: :string
      f.input :from, as: :string
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
        super
      else
        render 'admin/shared/paid_feature', layout: 'active_admin', locals: { feature_name: 'Mass emailing team managers' }
      end
    end

    def create
      @batch_email = BatchEmail.new(params[:batch_email])
      if @batch_email.valid? and current_tournament.mass_emailing_enabled?
        users = User.team_managers(current_subdomain, current_admin_user)
        SendBatchEmail.new(users, @batch_email.subject, @batch_email.content, @batch_email.from)
        redirect_to admin_registrations_path, notice: 'Sent email to team managers'
      end
    end

  end

end
