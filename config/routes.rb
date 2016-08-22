Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  namespace :api do
    get 'me', to: 'users#show'
  end

  root to: "home#index"

end
