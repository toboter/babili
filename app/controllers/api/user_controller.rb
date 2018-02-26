class Api::UserController < Api::BaseController
  load_and_authorize_resource :current_user

  def show
    render json: current_user
  end

  def repositories
    repositories = current_user.oread_enrolled_applications.order(id: :asc)
    render json: repositories, each_serializer: RepositorySerializer
  end

  def organizations
    organizations = current_user.organizations.where(private: false).order(id: :asc)
    render json: organizations, each_serializer: OrganizationSerializer
  end

end