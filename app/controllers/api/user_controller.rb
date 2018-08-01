# AccountController

class Api::UserController < Api::BaseController
  load_and_authorize_resource :current_user

  def show
    render json: current_user
  end

  def repositories
    collections = current_user.oread_enrolled_applications.order(id: :asc)
    render json: collections, each_serializer: CollectionSerializer
  end

  def organizations
    organizations = current_user.person.organizations.where(private: false).order(id: :asc)
    render json: organizations, each_serializer: OrganizationSerializer
  end

  # deprecated
    def me #user
      render json: current_user
    end

    # /api/my/accessibilities/crud/:uid
    def my_crud_abilities #applications_authorizations_client_url(uid)(user_permissions)
      application = Doorkeeper::Application.find_by_uid(params[:uid])
      grant = application.grants(current_user.person)
      render json: grant
    end

    # /api/my/accessibilities/searchable
    def my_search_abilities #user/repositories
      oread_applications = current_user.oread_token_applications.distinct
      render json: oread_applications, each_serializer: OreadApplicationSerializer
    end

    # /api/my/accessibilities/projects/:uid
    def my_app_organizations #applications_authorizations_client_url(uid)(organization_accessors)
      application = Doorkeeper::Application.find_by_uid(params[:uid])
      organizations = current_user.person.organizations.joins(:accessible_oauth_apps).where('oauth_applications.id = ?', application.id)
      render json: organizations
    end
  # end
end