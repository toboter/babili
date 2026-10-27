module Api::V1
  class RepositoriesController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource through: :namespace
    
    def index
      @pagy, @repositories = pagy(:offset, @repositories, limit: (params[:per_page] || 30).to_i)
      @meta = pagination_dict(@pagy)
      render template: "api/v1/repositories/index"
    end

    def show
      render template: "api/v1/repositories/show"
    end
  end
end