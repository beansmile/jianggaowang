Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Rails.application.secrets["sidekiq"]["username"] &&
    password == Rails.application.secrets["sidekiq"]["password"]
  end unless Rails.env.development?
  mount Sidekiq::Web => '/sidekiq'

  resources 'notifications', only: [] do
    collection do
      post :slide_uploaded
      post :persistance_finished
    end
  end

  resources :user_passwords, only: [:edit, :update] do
    collection do
      get :reset
      post :create_new
    end
  end

  resource :profile, only: [:show, :update, :edit] do
    collection do
      get 'events'
      get 'slides'
    end
  end

  get '/login' => 'sessions#new'
  delete '/logout' => 'sessions#destroy'
  resources :sessions, only: [:create]

  get '/signup' => 'users#new'
  resources :users, only: [:show, :create]

  resources :slides, only: [:index, :show, :create, :destroy, :edit, :update] do
    collection do
      get 'upload_result'
      get 'search'
      get 'hottest'
    end

    member do
      # post 'like'

      get 'process_retrieve'
      get 'manual_process'
    end
  end

  resources :events do
    collection do
      get 'choose'
      get 'search'
    end
    member do
      get 'slides/new' => 'slides#new'
    end
  end

  root 'home#index'

  resources :tags, only: :index
  get '/tags/:name', to: 'tags#show', as: 'tag_name'

  get '/static_page' => 'home#static_page'

  get '/s' => 'search#index', as: :search

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
