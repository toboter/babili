class Api::UserController < Api::BaseController
  load_and_authorize_resource :current_user

  def show
    render json: current_user
  end

  def repositories
    repositories = current_user.oread_enrolled_applications.order(id: :asc)
    render json: repositories, each_serializer: RepositorySerializer
  end

  def projects
    projects = current_user.projects.where(private: false).order(id: :asc)
    render json: projects, each_serializer: ProjectSerializer
  end

end