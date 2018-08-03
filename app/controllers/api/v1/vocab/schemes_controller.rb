module Api::V1::Vocab
  class SchemesController < Api::V1::BaseController
    load_and_authorize_resource class: 'Vocab::Scheme'

    def index
      sort_order = Vocab::Scheme.sorted_by(params[:sort].presence || 'updated_at_desc')
      @schemes = @schemes.where("updated_at > ?", params[:since]) if params[:since]
      @schemes = @schemes.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

      render json: @schemes, meta: pagination_dict(@schemes), each_serializer: SchemeSerializer, adapter: :json
    end

    def show
      render json: @scheme, serializer: SchemeSerializer, adapter: :json
    end
  end
end