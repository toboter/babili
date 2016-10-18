Rails.application.routes.draw do
  get 'search', to: 'search#index'

  use_doorkeeper
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  resources :users, only: [:index, :update]
  
  namespace :api do
    get 'me', to: 'users#me'
    get 'users', to: 'users#index'
  end
  namespace :search do
    resources :applications
  end

  resources :blogs, only: :index
  resources :abouts, path: :about, controller: 'blogs', type: 'About'
  resources :posts, controller: 'blogs', type: 'Post'
  resources :novelities, path: :news, controller: 'blogs', type: 'Novelity'

  get '/api', to: 'home#api'
  get '/help', to: 'home#help'
  get '/imprint', to: 'home#imprint'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'

  root to: "home#index"

end
