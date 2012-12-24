ActiveAdmin.register Payment do

  scope_to association_method: :call do
    lambda { Payment.where(registration_id: Registration.for_tournament(current_subdomain, current_admin_user).collect { |r| r.id }) }
  end

  scope :all, :default => true do |p|
    p.includes [ :registration ]
  end

  config.sort_order = "instituion_id desc , payments.id desc"

  index do
    column 'Inst', sortable: 'institutions.abbreviation' do |p|
      link_to p.registration.institution.abbreviation, admin_institution_path(p.registration.institution)
    end
    column 'Date', :date_sent
    column "Amount sent" do |p|
      number_to_currency p.amount_sent, unit: ''
    end
    column 'A/C #', :account_number
    column 'Comments', :comments
    column 'Proof'  do |p|
      link_to 'View', p.scanned_proof.url
    end
    column :created_at
    column "Amount received" do |p|
      number_to_currency p.amount_received, unit: ''
    end
    column 'Admin comment', :admin_comment
    default_actions
  end

  form do |f|
    if f.object.new_record? and f.object.date_sent.nil?
      f.object.date_sent = Date.today
    end
    f.inputs do
      disable_field = true unless f.object.new_record?
      f.input :registration, label: 'Institution', as: :select, collection: Hash[Registration.for_tournament(current_subdomain, current_admin_user).map{ |r| [r.institution_name,r.id]}],:input_html => { :disabled => disable_field }
      f.input :date_sent, :input_html => { :disabled => disable_field }
      f.input :amount_sent, as: :string, :input_html => { :disabled => disable_field }
      f.input :account_number, :input_html => { :disabled => disable_field }
      f.input :scanned_proof
      f.input :comments, :input_html => { :disabled => disable_field }
      if !f.object.new_record?
        f.input :created_at, :input_html => { :disabled => true }
      end 
      f.input :amount_received, as: :string
      f.input :admin_comment
      f.buttons
    end
  end

  controller do

    def new
      @payment = Payment.new
    end

    def create
      @payment = Payment.new(params[:payment])
      @payment.registration_id = params[:payment][:registration_id]
      @payment.amount_received = params[:payment][:amount_received]
      @payment.admin_comment = params[:payment][:admin_comment]
      if @payment.save
        @payment.send_payment_notification
        redirect_to admin_payments_path, notice: 'Payment was successfully updated.'
      else
        render action: "edit"
      end
    end

    def update
      @payment = Payment.find(params[:id])
      @payment.amount_received = params[:payment][:amount_received]
      @payment.admin_comment = params[:payment][:admin_comment]

      if @payment.save
        @payment.send_payment_notification
        redirect_to admin_payments_path, notice: 'Payment was successfully updated.'
      else
        render action: "edit"
      end
    end

  end

  filter :registration_team_manager_name, as: :select, collection: proc { User.paid_team_managers(current_subdomain, current_admin_user).order(:name).all.map(&:name) }
  filter :registration_institution_name, as: :select, collection: proc { Institution.paid_participating(current_subdomain, current_admin_user).order(:name).all.map(&:name) }
  filter :date_sent
  filter :amount_sent
  filter :comments
  filter :amount_received
  filter :admin_comment
end
