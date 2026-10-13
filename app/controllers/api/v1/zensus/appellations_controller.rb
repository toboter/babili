module Api::V1::Zensus
  class AppellationsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Zensus::Appellation'

    def index
      sort_order = Zensus::Appellation.sorted_by(params[:sort].presence || 'updated_at_desc')
      @appellations = @appellations.where("updated_at > ?", params[:since]) if params[:since]
      @appellations = @appellations.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

      render_with_serializer(@appellations, meta: pagination_dict(@appellations), each_serializer: AppellationSerializer)
    end

    def show
      render_with_serializer(@appellation, serializer: AppellationSerializer)
    end

    def create
      if @appellation.save
        render_with_serializer(@appellation, serializer: AppellationSerializer, status: :created)
      else
        render json: @appellation.errors, status: :unprocessable_entity
      end
    end

    def search
      @appellations = Zensus::Appellation.search(params[:q],
        fields: ['name^10', :agent],
        page: params[:page], 
        per_page: params[:per_page] || 30)

      render_with_serializer(@appellations, meta: pagination_dict(@appellations), each_serializer: AppellationSerializer)
    end

    private
    def appellation_params
      params.require(:appellation).permit(
        :language, 
        :period, 
        :trans, 
        :agent_id,
        appellation_parts_attributes: [
          :type,
          :body,
          :preferred,
          :_destroy
        ]
      )
    end
  end
end