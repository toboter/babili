class Api::ProjectsController < Api::BaseController
  load_and_authorize_resource

  def index
    projects = Project.where(private: false).order(id: :asc)
    render json: projects
  end

  def show
    # if private 403
    project = Project.where(private: false).find(params[:id])
    render json: project
  end
end