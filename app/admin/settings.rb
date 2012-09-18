ActiveAdmin.register Setting do
  actions :edit, :update, :index

  scope_to association_method: :call do
    lambda { Setting.for_tournament(current_subdomain, current_admin_user) }
  end

  index do 
    column :key
    column :value
    default_actions
  end

  csv do
    column :key
    column :value
  end

  form do |f|
    f.inputs do
      f.input :key
      f.input :value
    end
    f.buttons
  end

  controller do 
    def update
      @setting = Setting.find(params[:id])
      @setting.update_attributes(params[:setting])
      @setting.tournament = Tournament.find_by_identifier(current_subdomain) 

      if @setting.save
        redirect_to admin_settings_path, notice: 'Setting was successfully updated'
      else
        render action: "edit"
      end
    end
  end

  filter :key
  filter :value
end
