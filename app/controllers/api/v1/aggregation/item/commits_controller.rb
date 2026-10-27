module Api::V1::Aggregation
  class Item::CommitsController < Api::V1::BaseController
    load_and_authorize_resource :namespace
    load_and_authorize_resource :repository, through: :namespace
    load_and_authorize_resource :item, through: :repository, class: 'Aggregation::Item'
    load_and_authorize_resource through: :item, class: 'Aggregation::Commit'
    
    def index
      @pagy, @commits = pagy(:offset, @commits, limit: (params[:per_page] || 30).to_i)
      @meta = pagination_dict(@pagy)
      render template: "api/v1/aggregation/commits/index"
    end

    def show
      render template: "api/v1/aggregation/commits/show"
    end

  end
end