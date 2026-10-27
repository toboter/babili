# AccountController
module Api::V1
  class UserController < Api::V1::BaseController
    load_and_authorize_resource :current_user

    def show
      @user = current_user
      render template: "api/v1/user/show"
    end

    def repositories
      @collections = current_user.oread_enrolled_applications.order(id: :asc)
      render template: "api/v1/user/repositories"
    end

    def organizations
      @organizations = current_user.person.organizations.where(private: false).order(id: :asc)
      render template: "api/v1/user/organizations"
    end

    # deprecated
      def me #user
        render template: "api/v1/user/me"
      end

      # /api/my/accessibilities/crud/:uid
      def my_crud_abilities #applications_authorizations_client_url(uid)(user_permissions)
        application = Doorkeeper::Application.find_by_uid(params[:uid])
        @grants = Array.wrap(application.grants(current_user.person))
        render template: "api/v1/user/my_crud_abilities"
      end

      # /api/my/accessibilities/searchable
      def my_search_abilities #user/repositories
        @oread_applications = current_user.oread_token_applications.distinct
        render template: "api/v1/user/my_search_abilities"
      end

      # /api/my/accessibilities/projects/:uid
      def my_app_organizations #applications_authorizations_client_url(uid)(organization_accessors)
        application = Doorkeeper::Application.find_by_uid(params[:uid])
        @organizations = current_user.person.organizations.joins(:accessible_oauth_apps).where('oauth_applications.id = ?', application.id)
        render template: "api/v1/user/my_app_organizations"
      end
    # end
  end
end
