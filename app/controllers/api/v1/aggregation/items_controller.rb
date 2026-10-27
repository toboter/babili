module Api::V1::Aggregation
  class ItemsController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource :repository, through: :namespace
    load_and_authorize_resource through: :repository, class: 'Aggregation::Item'
    
    def index
      @items = @items.paginate(page: params[:page], per_page: params[:per_page] || 30)
      @meta = pagination_dict(@items)
      render template: "api/v1/aggregation/items/index"
    end

    def show
      render template: "api/v1/aggregation/items/show"
    end

  end
end