Rails.application.routes.draw do
  require 'sidekiq/web'

  get 'search', to: 'search#index'
  get '/api', to: 'home#api'  
  get '/help', to: 'home#help'
  get '/imprint', to: 'home#imprint'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'
  get :projects, to: 'home#projects'
  get '/collections/applications', to: 'home#collections', as: :collections

  scope 'oauth' do
    resources :applications, as: :oauth_application, only: :show, controller: 'doorkeeper/applications'
  end
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end
  namespace :oread, path: 'collections' do
    resources :applications, only: :show
  end

  get '/settings', to: redirect("/settings/profile")
  scope path: '/settings' do
    resources :projects, only: [:index, :new, :create, :edit, :update, :destroy], as: :settings_projects
    get 'profile', to: 'profiles#edit', as: 'edit_current_profile'
    resources :profiles, only: [:update], as: :settings_profiles
    
    devise_scope :user do
      get "/account" => "devise/registrations#edit"
    end
    use_doorkeeper do
      skip_controllers :tokens, :applications, :authorizations
    end
    #get '/security', to: 'security#index', as: 'security_settings'
    resource :security, only: :show, as: :security_settings do
      resources :user_sessions, only: :destroy
    end
    # '/security/revoke_user_session/', to: 'security#revoke_user_session', as: :settings_security_user_session_revoke
    # get '/collections', to: 'oread/access_enrollments#index', as: :settings_collections
    namespace :oread, as: :settings_oread do
      resources :access_enrollments, only: [:index, :create, :destroy], as: :enrollments, path: 'enrollments' do
        get 'restore_default', on: :collection
      end
      resources :oread_applications, only: [], as: :applications, path: 'applications' do
        resources :access_tokens,
        only: [:new, :create, :destroy], 
        as: :tokens, 
        path: 'tokens'
      end
    end

    get '/admin', to: redirect("/settings/admin/users"), as: 'admin_settings'
    scope path: 'admin' do
      resources :users, only: [:index, :update] do
        patch :approve, on: :member
        patch :make_admin, on: :member
      end
      namespace :oread, as: :settings_admin_oread do
        resources :applications, except: :show
      end
    end

    get '/developer', to: redirect("/settings/developer/oauth/applications"), as: 'developer_settings'
    scope path: 'developer' do
      use_doorkeeper do
        skip_controllers :authorizations, :tokens, :authorized_applications
      end
      scope :oauth do
        resources :applications, as: :oauth_application, except: :show do
          resources :oauth_accessibilities, 
            only: [:new, :edit, :create, :update, :destroy], 
            as: :accessibilities, 
            path: 'accessibilities'
          get 'send_accessibilities_to_clients', to: 'oauth_accessibilities#send_all_accessibilities_to_clients'
        end
      end
    end
  end
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, :controllers => { :registrations => :registrations }
  resources :profiles, only: [:index, :show]
  resources :projects, only: [:show]


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

  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: "home#index"

end
