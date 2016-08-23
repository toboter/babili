Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  namespace :api do
    get 'me', to: 'users#me'
    get 'users', to: 'users#index'
  end

  root to: "home#index"

end
