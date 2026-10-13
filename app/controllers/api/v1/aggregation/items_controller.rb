module Api::V1::Aggregation
  class ItemsController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource :repository, through: :namespace
    load_and_authorize_resource through: :repository, class: 'Aggregation::Item'
    
    def index
      @items = @items.paginate(page: params[:page], per_page: params[:per_page] || 30)
      render_with_serializer(@items, meta: pagination_dict(@items), each_serializer: ItemSerializer)
    end

    def show
      render_with_serializer(@item, serializer: ItemSerializer)
    end

  end
end