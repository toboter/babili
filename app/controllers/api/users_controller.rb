class Api::UsersController < Api::BaseController
  load_and_authorize_resource

  def index
    users = User.accessible_by(current_ability).all
    render json: users
  end

  def show
    user = User.accessible_by(current_ability).find(params[:id])
    render json: user
  end

  def me
    render json: current_resource_owner
  end

  # /api/my/accessibilities/crud/:uid
  def my_crud_abilities
    application = Doorkeeper::Application.find_by_uid(params[:uid])
    obj = OauthAccessibility.new(oauth_application_id: application.id)
    application.accessibilities.where(id: current_resource_owner.all_oauth_accessibilities.ids).each do |a|
      obj.can_manage = true if a.can_manage == true
      obj.can_create = true if a.can_create == true
      obj.can_read = true if a.can_read == true
      obj.can_update = true if a.can_update == true
      obj.can_destroy = true if a.can_destroy == true
      obj.can_comment = true if a.can_comment == true
      obj.can_publish = true if a.can_publish == true
    end
    # oauth_accessibilities = current_resource_owner.all_combined_oauth_accessibility_grants
    render json: obj, each_serializer: OauthAccessibilitySerializer
  end

  # /api/my/accessibilities/search
  def my_search_abilities
    oread_applications = current_resource_owner.oread_token_applications.distinct
    render json: oread_applications, each_serializer: OreadApplicationSerializer
  end

  # /api/my/accessibilities/projects/:uid
  def my_app_projects
    application = Doorkeeper::Application.find_by_uid(params[:uid])
    projects = current_resource_owner.projects.joins(:oauth_applications).where(oauth_applications: {id: application.id})
    render json: projects
  end

end