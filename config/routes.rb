Rails.application.routes.draw do
  get 'search', to: 'search#index'

  use_doorkeeper
  scope :oauth do
    resources :applications, as: :oauth_application do
      resources :oauth_accessibilities, 
        only: [:new, :create, :destroy], 
        as: :accessibilities, 
        path: 'accessibilities'
    end
  end
      

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  resources :users, only: [:index, :update]
  resources :profiles, except: [:destroy]
  
  namespace :api do
    get 'me', to: 'users#me'
    scope :my do
      get 'projects', to: 'projects#my_projects'
      scope :authorizations do
        get 'write', to: 'accessibilities#write_authorization'
        get 'read', to: 'accessibilities#read_authorization'
      end
    end
    resources :users, only: [:index, :show]
    resources :projects, only: [:index, :show]
    get 'search', to: 'search#index'
    post 'oread_application_access_token', to: 'oread_access_tokens#create'
  end

  namespace :oread do
    resources :applications do
      resources :oread_accessibilities, 
        only: [:new, :create, :destroy], 
        as: :accessibilities, 
        path: 'accessibilities',
        controller: '/oread_accessibilities'
      resources :access_tokens,
        only: [:new, :create, :destroy], 
        as: :tokens, 
        path: 'tokens'
    end
  end
  resources :projects do 
    resources :memberships
  end
  
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

  get '/api', to: 'home#api'
  get '/help', to: 'home#help'
  get '/imprint', to: 'home#imprint'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'

  root to: "home#index"

end
