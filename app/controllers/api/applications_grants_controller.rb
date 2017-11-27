class Api::ApplicationsGrantsController < Api::BaseController
  load_and_authorize_resource class: 'Doorkeeper::AccessGrant', find_by: :id
  before_action :check_grant?, only: :show

  def index
    grants = @applications_grants.where(resource_owner_id: current_user).order(id: :asc).uniq
    render json: grants, each_serializer: ApplicationsGrantSerializer
  end

  def show
    render json: @applications_grant, serializer: ApplicationsGrantSerializer
  end

  private
  def check_grant?
    unless @applications_grant.resource_owner_id == current_user.id
      render json: {message: 'Grant revoked', status: 302}
    end
  end
end