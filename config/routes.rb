Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do
      get 'user', to: 'users#show'
    end
  end

  root to: "home#index"

end
