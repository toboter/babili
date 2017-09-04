module Doorkeeper
  class ApplicationsController < ActionController::Base
    before_action :authenticate_user!, except: [:index, :show]
    load_and_authorize_resource :application, class: 'Doorkeeper::Application'
  end
end