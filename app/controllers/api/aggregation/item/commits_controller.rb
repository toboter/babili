class Api::Aggregation::Item::CommitsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository, class: 'Aggregation::Item'
  load_and_authorize_resource through: :item, class: 'Aggregation::Commit'
  
  def index
    @commits = @commits.paginate(page: params[:page], per_page: params[:per_page] || 30)
    render json: @commits, meta: pagination_dict(@commits), each_serializer: Aggregation::CommitSerializer, adapter: :json
  end

  def show
    render json: @commit, serializer: Aggregation::CommitSerializer, adapter: :json
  end

end