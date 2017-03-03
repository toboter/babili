class Api::ProjectsController < Api::BaseController
  load_and_authorize_resource
  # skip_authorization_check

  def index
    projects = Project.accessible_by(current_ability).all
    render json: projects
  end

  def my_projects
    projects = current_resource_owner.projects
    render json: projects
  end

  def show
    project = Project.accessible_by(current_ability).find(params[:id])
    render json: project
  end
end