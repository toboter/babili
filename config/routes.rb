Rails.application.routes.draw do
  get 'search', to: 'search#index'

  use_doorkeeper
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  namespace :api do
    get 'me', to: 'users#me'
    get 'users', to: 'users#index'
  end

  get '/api', to: 'home#api'
  get '/help', to: 'home#help'
  get '/imprint', to: 'home#imprint'
  get '/contact', to: 'home#contact'
  get '/explore', to: 'home#explore'

  root to: "home#index"

end
