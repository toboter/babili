Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  get 'search', to: 'search#index'
  get '/api', to: 'home#api'  
  get '/help', to: 'home#help'
  get '/imprint', to: 'home#imprint'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'

  use_doorkeeper
  scope :oauth do
    resources :applications, as: :oauth_application do
      resources :oauth_accessibilities, 
        only: [:new, :edit, :create, :update, :destroy], 
        as: :accessibilities, 
        path: 'accessibilities'
      get 'send_accessibilities_to_clients', to: 'oauth_accessibilities#send_all_accessibilities_to_clients'
    end
  end
  
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  resources :users, only: [:index, :update]
  resources :profiles, except: [:destroy]

  namespace :api do

    get 'me', to: 'users#me'
    scope :my do
      get 'projects', to: 'users#my_projects'         #old please delete
      scope :authorizations do
        get 'read', to: 'users#my_search_abilities'   #old please delete
      end
      #new
      scope :accessibilities do
        get 'searchable', to: 'users#my_search_abilities'
        get 'crud/:uid', to: 'users#my_crud_abilities'
        get 'projects/:uid', to: 'users#my_app_projects'
      end
    end

    resources :users, only: [:index, :show]
    resources :projects, only: [:index, :show]
    get 'search', to: 'search#index'
    post 'oread_application_access_token', to: 'oread_access_tokens#create'   #old please delete
    resources :oread_applications, only: [] do
      post 'set_access_token', to: 'oread_access_tokens#create', on: :collection
    end

  end

  namespace :oread do
    resources :applications do
      # resources :oread_accessibilities, 
      #   only: [:new, :create, :destroy], 
      #   as: :accessibilities, 
      #   path: 'accessibilities',
      #   controller: '/oread_accessibilities'
      resources :access_tokens,
        only: [:new, :create, :destroy], 
        as: :tokens, 
        path: 'tokens'
    end
  end
  resources :projects
  
  resources :blogs, only: :index
  resources :abouts, path: :about, controller: 'blogs', type: 'About' do 
    member do
      put :move
    end
  end
  resources :posts, controller: 'blogs', type: 'Post' do 
    member do
      put :move
    end
  end
  resources :novelities, path: :news, controller: 'blogs', type: 'Novelity'

  root to: "home#index"

end
