class Api::UserController < Api::BaseController
  load_and_authorize_resource :current_user

  def show
    render json: current_user
  end

  def collections
    collections = current_user.oread_enrolled_applications.order(id: :asc)
    render json: collections, each_serializer: CollectionSerializer
  end

  def projects
    projects = current_user.projects.where(private: false).order(id: :asc)
    render json: projects, each_serializer: ProjectSerializer
  end

  def applications
    applications = current_user.oauth_applications
    render json: applications
  end
end