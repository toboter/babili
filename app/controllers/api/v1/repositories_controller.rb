module Api::V1
  class RepositoriesController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource through: :namespace
    
    def index
      @repositories = @repositories.paginate(page: params[:page], per_page: params[:per_page] || 30)
      @meta = pagination_dict(@repositories)
      render template: "api/v1/repositories/index"
    end

    def show
      render template: "api/v1/repositories/show"
    end
  end
end