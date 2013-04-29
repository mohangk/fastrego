UadcRego::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  match '/' => 'pages#homepage', constraints: { subdomain: /www|$^/ }

  root :to => "users#show"

  resources :institutions, only: [:new, :create, :index]
  resources :universities, only: [:new, :create, :index], controller: 'instutitons'
  resources :open_institutions, only: [:new, :create, :index], controller: 'instutitons'
  resources :high_schools, only: [:new, :create, :index], controller: 'instutitons'

  resource :registration, only: [:new, :create, :update] do
    member do
      get 'edit_debaters'
      put 'update_debaters'
      get 'edit_adjudicators'
      put 'update_adjudicators'
      get 'edit_observers'
      put 'update_observers'
    end
  end

  resources :manual_payments, only: [:create, :destroy], controller: 'payments'
  resources :payments, only: [:show, :create, :destroy] do
    member do
      get 'canceled'  => 'payments#canceled'
      get 'completed' => 'payments#completed'
    end
  end

  match 'checkout'  => 'payments#checkout'
  match 'ipn'       => 'payments#ipn'


  match "profile"      => "users#show", as: :profile, via: :get
  match "registration" => redirect('/profile'), via: :get
  match "payments"     => redirect('/profile'), via: :get

  match "embed_logo" => "pages#embed_logo", as: :embed_logo, via: :get
  match 'enquiry' => 'pages#enquiry', as: :enquiry, via: :get
  match 'enquiry' => 'pages#send_enquiry', as: :enquiry, via: :post
  match 'paypal_payment_notice'  => 'pages#paypal_payment_notice'

  match "export/institution" => "export#institution", via: :get
  match "export/adjudicator" => "export#adjudicator", via: :get
  match "export/team" => "export#team", via: :get
  match "export/debater" => "export#debater", via: :get
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
