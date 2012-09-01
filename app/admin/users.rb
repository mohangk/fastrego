ActiveAdmin.register User do
  actions :all, :except => [:new, :edit, :delete]
  scope_to association_method: :call do
    lambda { User.where(id: current_admin_user.registrations.collect { |r| r.team_manager.id }) }
  end
  menu label: 'Team manager'
  
  #scope :all, :default => true do |users|
  #  users.includes [:registraton]
  #end


  index do
    column :id
    column :name
    column :email
    #column :institution, :sortable => :'institutions.name'
    column :phone_number
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    default_actions
  end

  #filter :institution, collection: proc { Institution.order(:name).all }
  filter :email
  filter :name
  filter :phone_number

  #TODO: not putting the collection value into a proc might result in the "table not found" issue
  form do |f|
    f.inputs "Team manager details" do
      #f.input :institution, collection:  Institution.order(:name).all 
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone_number
      f.input :send_reset_password_email, as: :boolean, default: true,
              label: 'Select this checkbox if you would like to send an email to the team manager to reset her account password'
    end
    f.buttons
  end

  controller do
    def create
      @user = User.new(params[:user])
      #if the admin creates the user, we skip confirmation and rely 
      @user.skip_confirmation!
      @user.send_reset_password_instructions if params[:user][:send_reset_password_email] == '1'

      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_users_url, notice: 'Team manager was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end

  end

end
