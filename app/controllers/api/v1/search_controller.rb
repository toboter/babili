module Api::V1
  class SearchController < Api::V1::BaseController
    require "json"
    include ERB::Util
    include OreadRemoteSearch

    skip_before_action :doorkeeper_authorize!
    skip_before_action :authenticate_user_with_doorkeeper!
    skip_authorization_check

    before_action :authenticate_user_with_personal_token!
    before_action -> { authorize_personal_api_methods(:search) }, only: :index

    def index
      @results = []
      if params[:q].present?
        @results, @failed_connections = search_oread_remotes(params[:q])
      end
      render json: @results
    end
  end
end
