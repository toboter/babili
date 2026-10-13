module Api::V1
  class RepositoriesController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource through: :namespace
    
    def index
      @repositories = @repositories.paginate(page: params[:page], per_page: params[:per_page] || 30)
      render_with_serializer(@repositories, meta: pagination_dict(@repositories), each_serializer: RepositorySerializer)
    end

    def show
      render_with_serializer(@repository, serializer: RepositorySerializer)
    end
  end
end