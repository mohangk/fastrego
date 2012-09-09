ActiveAdmin.register Institution do
  actions :show, :index
  config.sort_order = "name_asc"
end
