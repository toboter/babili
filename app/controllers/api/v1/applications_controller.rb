module Api::V1
  class ApplicationsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Doorkeeper::Application', find_by: :uid

    def index
      applications = @applications.order(id: :asc)
      render_with_serializer(applications, each_serializer: ApplicationSerializer)
    end

    def show
      render_with_serializer(@application, serializer: ApplicationSerializer)
    end

  end
end