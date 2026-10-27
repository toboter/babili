module Api::V1
  class ApplicationsGrantsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Doorkeeper::AccessGrant', find_by: :id
    before_action :check_grant?, only: :show

    def index
      grants = @applications_grants.where(resource_owner_id: current_user).order(id: :asc).uniq
      @grants = grants
      render template: "api/v1/applications_grants/index"
    end

    def show
      render template: "api/v1/applications_grants/show"
    end

    private
    def check_grant?
      unless @applications_grant.resource_owner_id == current_user.id
        render json: {message: 'Grant revoked', status: 302}
      end
    end
  end
end