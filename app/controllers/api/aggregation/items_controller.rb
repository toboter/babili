class Api::Aggregation::ItemsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository, class: 'Aggregation::Item'
  
  def index
    @items = @items.paginate(page: params[:page], per_page: params[:per_page] || 30)
    render json: @items, meta: pagination_dict(@items), each_serializer: Aggregation::ItemSerializer, adapter: :json
  end

  def show
    render json: @item, serializer: Aggregation::ItemSerializer, adapter: :json
  end

end