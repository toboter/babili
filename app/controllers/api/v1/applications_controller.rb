module Api::V1
  class ApplicationsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Doorkeeper::Application', find_by: :uid

    def index
      applications = @applications.order(id: :asc)
      @applications = applications
      render template: "api/v1/applications/index"
    end

    def show
      render template: "api/v1/applications/show"
    end

  end
end