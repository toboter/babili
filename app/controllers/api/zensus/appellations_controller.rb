class Api::Zensus::AppellationsController < Api::BaseController
  load_and_authorize_resource class: 'Zensus::Appellation'

  def index
    sort_order = Zensus::Appellation.sorted_by(params[:sort].presence || 'updated_at_desc')
    @appellations = @appellations.where("updated_at > ?", params[:since]) if params[:since]
    @appellations = @appellations.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

    render json: @appellations, meta: pagination_dict(@appellations), each_serializer: Zensus::AppellationSerializer, adapter: :json
  end

  def show
    render json: @appellation, serializer: Zensus::AppellationSerializer, adapter: :json
  end

  def create
    if @appellation.save
      render json: @appellation, status: :created
    else
      render json: @appellation.errors, status: :unprocessable_entity
    end
  end

  def search
    @appellations = Zensus::Appellation.search(params[:q],
      fields: ['name^10', :agent],
      page: params[:page], 
      per_page: params[:per_page] || 30)

    render json: @appellations, meta: pagination_dict(@appellations), each_serializer: Zensus::AppellationSerializer, adapter: :json
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