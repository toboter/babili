module Api::V1::Vocab
  class SchemesController < Api::V1::BaseController
    load_and_authorize_resource class: 'Vocab::Scheme'

    def index
      sort_order = Vocab::Scheme.sorted_by(params[:sort].presence || 'updated_at_desc')
      @schemes = @schemes.where("updated_at > ?", params[:since]) if params[:since]
      @pagy, @schemes = pagy(:offset, @schemes.order(sort_order), limit: (params[:per_page] || 30).to_i)

      @meta = pagination_dict(@pagy)
      render template: "api/v1/vocab/schemes/index"
    end

    def show
      render template: "api/v1/vocab/schemes/show"
    end
  end
end