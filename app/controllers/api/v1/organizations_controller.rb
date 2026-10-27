module Api::V1
  class OrganizationsController < Api::V1::BaseController
    load_and_authorize_resource

    def index
      @organizations = @organizations.where(private: false).order(id: :asc)
      render template: "api/v1/organizations/index"
    end

    def show
      if @organization.private?
        render json: {status: 'Not Found', code: 404}.to_json
      else
        render template: "api/v1/organizations/show"
      end
    end

  end
end
