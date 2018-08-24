Rails.application.routes.draw do
  namespace :raw do
    get '/', to: redirect(subdomain: false, path: '/')
    resources :file_uploads, path: 'files', except: :index
  end

  constraints subdomain: 'api' do
    get '/', to: redirect(subdomain: false, path: "/help/categories/api")
    scope module: 'api' do
      namespace :v1 do
        get '/', to: redirect(subdomain: false, path: "/help/categories/api")
        # deprecated start
          get 'me', to: 'user#me'
          scope :my do
            scope :accessibilities do
              get 'searchable', to: 'user#my_search_abilities'
              get 'crud/:uid', to: 'user#my_crud_abilities'
              get 'projects/:uid', to: 'user#my_app_organizations'
            end
          end
          resources :oread_applications, only: [] do
            post 'set_access_token', to: 'oread_access_tokens#create', on: :collection
          end
        # deprecated end

        # People
        resources :people, only: [:index, :show] do
          get 'organizations', on: :member
          get 'memberships', on: :member
          get 'repositories', on: :member
        end
        resource :user, only: [:show], controller: 'user' do     # was get 'me', to: 'users#me'
          get 'repositories', on: :member                        # was get 'searchable', to: 'users#my_search_abilities'
          get 'organizations', on: :member
        end

        # Organizations
        resources :organizations, only: [:index, :show] do
          resources :members, only: [:index, :show]
          resources :memberships, only: :show
          get :search, on: :collection
        end

        # Collections
        resources :collections, only: [:index, :show] do
          get 'resources/:uid', to: 'collections#resource_host', on: :collection
          resources :access_tokens, controller: 'collection_access_tokens', path: 'tokens' # was post 'set_access_token', to: 'oread_access_tokens#create'
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

        # locate
        namespace :locate do
          resources :places, only: [:index, :show]
        end

        # biblio

        namespace :biblio, path: 'bibliography' do
          resources :entries, only: :index
          resources :series, type: 'Biblio::Serie'
          resources :journals, type: 'Biblio::Journal'
          resources :books, controller: 'entries', type: 'Biblio::Book', except: :index
          resources :in_books, controller: 'entries', type: 'Biblio::InBook', except: :index
          resources :collections, controller: 'entries', type: 'Biblio::Collection', except: :index
          resources :in_collections, controller: 'entries', type: 'Biblio::InCollection', except: :index
          resources :proceedings, controller: 'entries', type: 'Biblio::Proceeding', except: :index
          resources :in_proceedings, controller: 'entries', type: 'Biblio::InProceeding', except: :index
          resources :articles, controller: 'entries', type: 'Biblio::Article', except: :index
          resources :miscs, controller: 'entries', type: 'Biblio::Misc', except: :index
          resources :manuals, controller: 'entries', type: 'Biblio::Manual', except: :index
          resources :booklets, controller: 'entries', type: 'Biblio::Booklet', except: :index
          resources :mastertheses, controller: 'entries', type: 'Biblio::Masterthesis', except: :index
          resources :phdtheses, controller: 'entries', type: 'Biblio::Phdthesis', except: :index
          resources :techreports, controller: 'entries', type: 'Biblio::Techreport', except: :index
          resources :unpublisheds, controller: 'entries', type: 'Biblio::Unpublished', except: :index
        end


        scope path: :search do
          get '/', to: 'search#index'               # global
          get :agents, to: 'zensus/agents#search'
          get :events, to: 'zensus/events#search'
          get :names, to: 'zensus/appellations#search'
          get :concepts, to: 'vocab/concepts#search'
        end

        resources :identifiers, only: [:index, :show], path: 'boi', module: 'aggregation'

        resources :namespaces, only: [], path: '' do
          # vocab
          namespace :vocab do
            resources :schemes, only: [:index, :show] do
              resources :concepts, only: [:index, :show]
            end
            get :concepts, to: 'concepts#full_index'
          end
          # repos
          resources :repositories, only: [:index, :show] do
            namespace :biblio, path: 'bibliography' do
              resources :references, controller: 'referencations', only: :index, path: ''
            end
            namespace :aggregation, path: 'data' do
              resources :events do
                resources :commits, module: 'event'
              end
              resources :items, only: [:index, :show] do
                resources :commits, module: 'item'
              end
            end
          end
        end
      end
      # namespace :v2 do
      # end
    end
    use_doorkeeper do
      # use_doorkeeper :tokens, :authorizations
      skip_controllers :applications, :authorized_applications
    end
  end

  constraints lambda { |r| r.subdomain != 'raw' && r.subdomain != 'api' } do

    # doorkeeper paths
    # tokens => api.host/...
    # authorizations => api.host/...
    # authorized_applications => /settings/oauth/authorized_applications
    # applications => /settings/developer/oauth/applications

    scope 'oauth' do
      resources :applications, as: :oauth_application, only: [:destroy, :show], controller: 'doorkeeper/applications'
    end
    scope path: '/settings' do
      use_doorkeeper do
        # use_doorkeeper :authorized_applications
        skip_controllers :tokens, :applications, :authorizations
      end
      scope path: 'developer' do
        use_doorkeeper do
          # use_doorkeeper :applications
          skip_controllers :authorizations, :tokens, :authorized_applications
        end
        scope :oauth do
          resources :applications, as: :oauth_application, except: [:destroy, :show] do
            resources :oauth_accessibilities, 
              except: :show, 
              as: :accessibilities, 
              path: 'accessibilities'
            get 'send_accessibilities_to_clients', to: 'oauth_accessibilities#send_accessibilities_to_app'
          end
        end
      end
    end

    # end doorkeeper paths

    require 'sidekiq/web'

    get '/discussions', to: 'home#discussions'
    concern :discussable do
      namespace 'discussion', path: '' do
        resources :threads, path: :discussions, controller: '/discussion/threads' do
          member do
            put 'close'
            put 'toggle_lock'
          end
          resources :comments, controller: '/discussion/comments', except: [:index]
          resources :assignments, controller: '/discussion/assignments', only: [:index, :new, :create, :destroy]
        end
      end
    end

    namespace :vocab, path: :vocabularies do
      get '/', to: 'home#index'
      get '/search', to: 'search#index'
      get '/search/terms', to: 'search#terms'
    end

    namespace :biblio, path: 'bibliography' do
      get '/', to: 'home#index'
      resources :entries, only: :index do
        post :add_repositories, to: 'referencations#add_repository', on: :member
      end
      resources :series, type: 'Biblio::Serie'
      resources :journals, type: 'Biblio::Journal'
      resources :books, controller: 'entries', type: 'Biblio::Book', except: :index
      resources :in_books, controller: 'entries', type: 'Biblio::InBook', except: :index
      resources :collections, controller: 'entries', type: 'Biblio::Collection', except: :index
      resources :in_collections, controller: 'entries', type: 'Biblio::InCollection', except: :index
      resources :proceedings, controller: 'entries', type: 'Biblio::Proceeding', except: :index
      resources :in_proceedings, controller: 'entries', type: 'Biblio::InProceeding', except: :index
      resources :articles, controller: 'entries', type: 'Biblio::Article', except: :index
      resources :miscs, controller: 'entries', type: 'Biblio::Misc', except: :index
      resources :manuals, controller: 'entries', type: 'Biblio::Manual', except: :index
      resources :booklets, controller: 'entries', type: 'Biblio::Booklet', except: :index
      resources :mastertheses, controller: 'entries', type: 'Biblio::Masterthesis', except: :index
      resources :phdtheses, controller: 'entries', type: 'Biblio::Phdthesis', except: :index
      resources :techreports, controller: 'entries', type: 'Biblio::Techreport', except: :index
      resources :unpublisheds, controller: 'entries', type: 'Biblio::Unpublished', except: :index
      resource :import
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

    namespace :aggregation, path: 'data' do
      get '/', to: 'home#index'
      get '/search', to: 'search#index'
      resources :identifiers, only: [:index, :show], path: 'boi'
    end

    devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, :controllers => { :registrations => :registrations }
    
    get '/search', to: 'search#index'
    get '/about', to: 'home#about'
    get '/explore', to: 'home#explore'
    get '/research/people', to: 'home#people', as: :people
    get '/research/organizations', to: 'home#organizations', as: :organizations
    get '/repositories', to: 'home#repositories'
    get '/collections/applications', to: 'home#collections', as: :collections

    namespace :oread, path: 'collections' do
      resources :applications, only: :show
    end

    namespace :settings do
      get '/', to: redirect("/settings/person")
      resources :organizations, only: [:index, :new, :create, :edit, :update, :destroy] do
        resources :memberships, only: [:create, :destroy]
        resource :namespace, only: [:edit, :update], type: 'Organization', path_names: { edit: 'change' }
      end
      resource :person, only: [:edit, :update], path_names: { edit: '' } do
        resource :namespace, only: [:edit, :update], type: 'Person', path_names: { edit: 'change' }
      end
      resource :security, only: :show do
        resources :user_sessions, only: :destroy
      end
    end

    scope path: '/settings' do
      
      devise_scope :user do
        get "/account" => "devise/registrations#edit"
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
        resources :users, only: [:index, :update, :destroy] do
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



    get '/contact', to: 'contact_messages#new'
    post '/contacts', to: 'contact_messages#create'

    root to: "home#index"
    
    get '/internal/mentionees', to: 'mentions#mentionees'
    get '/internal/referenceables', to: 'references#referenceables'

    resources :namespaces, only: :show, path: '' do
      resources :members, only: :index
      resources :applications
      namespace :vocab, path: 'vocabularies' do
        resources :schemes, path: '' do
          get :search, to: 'concepts#index'
          resources :concepts
        end
      end
      resources :repositories, concerns: :discussable do
        get :settings, on: :member
        get :edit_topics, on: :member
        put :update_topics, on: :member
        namespace :biblio, path: 'bibliography' do
          resources :references, controller: 'referencations', only: [:index, :destroy] do
            post :add_entry, to: 'referencations#add_entry', on: :collection
          end
        end
        namespace :aggregation, path: 'data' do
          namespace :event, path: 'events' do
            resources :upload_events, path: 'upload', only: [:new, :create]
            # resources :list_transforms, only: [:new, :create] # gehört an lists/:id/transform
          end
          resources :events, only: [:index, :show, :destroy] do
            put 'commit', on: :member, to: 'events#commit'
          end
          resources :items, only: [:index, :show] do 
            resources :commits, only: [:index, :show]
          end
        end
        resources :docs
      end
    end
  end
end
