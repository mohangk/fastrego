ActiveAdmin.register User do
  actions :show, :index
  scope_to :current_admin_user, association_method: :team_managers 
  menu label: 'Team manager'
  
  index do
    column :id
    column :name
    column :email
    column :phone_number
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    default_actions
  end

  filter :email
  filter :name
  filter :phone_number

  form do |f|
    f.inputs "Team manager details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone_number
      f.buttons
    end
  end
end
