module Api
  module V1
    class UsersController < BaseController
      before_action :doorkeeper_authorize!
      
      def show
        render json: current_resource_owner.as_json(except: :encrypted_password)
      end
    end
  end
end