module Api::V1
  class ApplicationsAuthorizationsController < Api::V1::BaseController
    before_action :load_authorized_applications

    def index
      authorize! :read, Doorkeeper::Application
      render template: "api/v1/applications_authorizations/index"
    end

    def show
      @authorized_application = @authorized_applications.find(params[:id])
      authorize! :read, @authorized_application
      render template: "api/v1/applications_authorizations/show"
    end

    def client
      @authorized_application = @authorized_applications.find_by_uid(params[:uid])
      authorize! :read, @authorized_application
      render template: "api/v1/applications_authorizations/client"
    end

    private
    def load_authorized_applications
      @authorized_applications = Doorkeeper::Application.authorized_for(current_user)
    end

  end
end
