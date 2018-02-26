Rails.application.routes.draw do
  require 'sidekiq/web'

  namespace :vocab, path: :vocabularies do
    get '/', to: 'home#index'
    get '/search', to: 'search#index'
    get '/search/terms', to: 'search#terms'
    resources :schemes do
      resources :concepts
    end
  end

  namespace :zensus do
    get '/', to: 'home#index'
    get :search, to: 'search#index'
    resources :names, controller: 'appellations'
    resources :agents do
      collection do
        resources :people, controller: 'agents', type: 'Zensus::Person'
        resources :groups, controller: 'agents', type: 'Zensus::Group'
      end
    end
    resources :events do
      resources :activities
    end
  end

  namespace :locate do
    get '/', to: 'home#index'
    get '/search', to: 'search#index'
    resources :places do
      resources :locations
    end
  end

  get '/search', to: 'search#index'
  get '/about', to: 'home#about'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'
  get '/organizations', to: 'home#organizations'
  get '/collections/applications', to: 'home#collections', as: :collections

  namespace :oread, path: 'collections' do
    resources :applications, only: :show
  end

  get '/settings', to: redirect("/settings/profile")
  scope path: '/settings' do
    resources :organizations, only: [:index, :new, :create, :edit, :update, :destroy], as: :settings_organizations do
      resources :memberships, only: [:create, :destroy]
    end
    get 'profile', to: 'profiles#edit', as: 'edit_current_profile'
    resources :profiles, only: [:update], as: :settings_profiles
    
    devise_scope :user do
      get "/account" => "devise/registrations#edit"
    end

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
      namespace :cms, path: nil do
        namespace :admin, path: nil do
          resources :help_categories, except: :show do
            put :move, on: :member
          end
          resources :blog_categories, except: :show
        end
      end 
    end

    get '/developer', to: redirect("/settings/developer/oauth/applications"), as: 'developer_settings'
    scope path: 'developer' do
      resources :personal_access_tokens, except: :show
    end
  end

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, :controllers => { :registrations => :registrations }
  resources :profiles, only: [:index, :show]
  resources :organizations, only: [:show]

  namespace :cms, path: nil do
    resources :blog_pages, path: :blog, only: :index
    scope path: :blog do
      resources :blog_categories, only: :show, path: 'categories' do
        get 'all', on: :collection
        get 'unpublished', to: 'blog_categories#unpublished_blogs', on: :collection
      end
      resources :blog_pages, path: '', except: :index
    end
    resources :help_pages, path: :help, only: [:index, :create]
    scope path: :help do
      resources :help_categories, only: :show, path: 'categories'
      resources :help_pages, path: :articles, except: [:index, :create]
    end
    resources :novelities, path: :news, except: :show
  end

  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end


  namespace :api do
    # deprecated start
      get 'me', to: 'users#me'
      scope :my do
        scope :accessibilities do
          get 'searchable', to: 'users#my_search_abilities'
          get 'crud/:uid', to: 'users#my_crud_abilities'
          get 'projects/:uid', to: 'users#my_app_organizations'
        end
      end
      resources :oread_applications, only: [] do
        post 'set_access_token', to: 'oread_access_tokens#create', on: :collection
      end
    # deprecated end

    # Users
    resources :users, only: [:index, :show] do
      get 'organizations', on: :member
      get 'repositories', on: :member
    end
    resource :user, only: [:show], controller: 'user' do      # was get 'me', to: 'users#me'
      get 'repositories', on: :member                          # was get 'searchable', to: 'users#my_search_abilities'
      get 'organizations', on: :member
    end

    # Organizations
    resources :organizations, only: [:index, :show] do
      resources :members, only: [:index, :show]
      resources :memberships, only: :show
      get :search, on: :collection
    end

    # Repositories
    resources :repositories, only: [:index, :show] do
      get 'resources/:uid', to: 'repositories#resource_host', on: :collection
      resources :access_tokens, controller: 'repository_access_tokens', path: 'tokens' # was post 'set_access_token', to: 'oread_access_tokens#create'
    end

    # Applications
    resources :applications, only: [:index, :show] do
      collection do
        resources :grants, controller: 'applications_grants'
      end
    end
    resources :authorizations, controller: 'applications_authorizations' do
      get 'clients/:uid', to: 'applications_authorizations#client', on: :collection
    end

    # Zensus
    namespace :zensus do
      resources :agents, only: [:index, :show] do
        collection do
          resources :people, controller: 'agents', type: 'Zensus::Person'
          resources :groups, controller: 'agents', type: 'Zensus::Group'
        end
      end
      resources :events, only: [:index, :show]
      resources :properties, only: [:index, :show]
      resources :names, controller: 'appellations', only: [:index, :show, :create]
    end

    # vocab
    namespace :vocab do
      resources :schemes, only: [:index, :show] do
        resources :concepts, only: [:index, :show]
      end
      get :concepts, to: 'concepts#full_index'
    end

    scope path: :search do
      get '/', to: 'search#index'               # global
      get :agents, to: 'zensus/agents#search'
      get :events, to: 'zensus/events#search'
      get :names, to: 'zensus/appellations#search'
      get :concepts, to: 'vocab/concepts#search'
    end


  end

  # doorkeeper paths
  scope 'oauth' do
    resources :applications, as: :oauth_application, only: [:destroy, :show], controller: 'doorkeeper/applications'
  end
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications #tokens, authorizations
  end
  scope path: '/settings' do
    use_doorkeeper do
      skip_controllers :tokens, :applications, :authorizations
    end
    scope path: 'developer' do
      use_doorkeeper do
        skip_controllers :authorizations, :tokens, :authorized_applications
      end
      scope :oauth do
        resources :applications, as: :oauth_application, except: [:destroy, :show] do
          resources :oauth_accessibilities, 
            except: :show, 
            as: :accessibilities, 
            path: 'accessibilities'
          get 'send_accessibilities_to_clients', to: 'oauth_accessibilities#send_all_accessibilities_to_clients'
        end
      end
    end
  end
  # end doorkeeper paths

  root to: "home#index"

end
