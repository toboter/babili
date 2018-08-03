module Api::V1
  class RepositoriesController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource through: :namespace
    
    def index
      @repositories = @repositories.paginate(page: params[:page], per_page: params[:per_page] || 30)
      render json: @repositories, meta: pagination_dict(@repositories), each_serializer: RepositorySerializer, adapter: :json
    end

    def show
      render json: @repository, serializer: RepositorySerializer, adapter: :json
    end
  end
end