class Api::ProjectsController < Api::BaseController
  load_and_authorize_resource

  def index
    projects = Project.accessible_by(current_ability).all
    render json: projects
  end

  def show
    project = Project.accessible_by(current_ability).find(params[:id])
    render json: project
  end
end