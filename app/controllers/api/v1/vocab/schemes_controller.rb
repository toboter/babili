module Api::V1::Vocab
  class SchemesController < Api::V1::BaseController
    load_and_authorize_resource class: 'Vocab::Scheme'

    def index
      sort_order = Vocab::Scheme.sorted_by(params[:sort].presence || 'updated_at_desc')
      @schemes = @schemes.where("updated_at > ?", params[:since]) if params[:since]
      @schemes = @schemes.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

      @meta = pagination_dict(@schemes)
      render template: "api/v1/vocab/schemes/index"
    end

    def show
      render template: "api/v1/vocab/schemes/show"
    end
  end
end