ActiveAdmin.register User do

  scope :all, :default => true do |users|
    users.includes [:institution]
  end

  index do
    column :id
    column :name
    column :email
    column :institution, :sortable => :'institutions.name'
    column :phone_number
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    default_actions
  end

  filter :institution, collection: Institution.order(:name).all.map(&:name)
  filter :email
  filter :name
  filter :phone_number

end
