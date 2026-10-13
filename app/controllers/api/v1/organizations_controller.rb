module Api::V1
  class OrganizationsController < Api::V1::BaseController
    load_and_authorize_resource

    def index
      organizations = @organizations.where(private: false).order(id: :asc)
      render_with_serializer(organizations, each_serializer: OrganizationSerializer)
    end

    def show
      @organization.private? ? (render json: {status: 'Not Found', code: 404}.to_json) : (render_with_serializer(@organization, serializer: OrganizationSerializer))
    end

  end
end