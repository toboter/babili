module Api::V1::Zensus
  class AppellationsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Zensus::Appellation'

    def index
      sort_order = Zensus::Appellation.sorted_by(params[:sort].presence || 'updated_at_desc')
      @appellations = @appellations.where("updated_at > ?", params[:since]) if params[:since]
      @pagy, @appellations = pagy(:offset, @appellations.order(sort_order), limit: (params[:per_page] || 30).to_i)

      @meta = pagination_dict(@pagy)
      render template: "api/v1/zensus/appellations/index"
    end

    def show
      render template: "api/v1/zensus/appellations/show"
    end

    def create
      if @appellation.save
        render template: "api/v1/zensus/appellations/create", status: :created
      else
        render json: @appellation.errors, status: :unprocessable_entity
      end
    end

    def search
      @appellations = Zensus::Appellation.search(params[:q],
        fields: ['name^10', :agent],
        page: params[:page], 
        per_page: params[:per_page] || 30)

      @pagy = pagy(:searchkick, @appellations)
      @meta = pagination_dict(@pagy)
      render template: "api/v1/zensus/appellations/search"
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
