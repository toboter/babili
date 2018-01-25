class Api::Zensus::EventsController < Api::BaseController
  load_and_authorize_resource class: 'Zensus::Event'

  def index
    sort_order = Zensus::Event.sorted_by(params[:sort].presence || 'updated_at_desc')
    @events = @events.where("updated_at > ?", params[:since]) if params[:since]
    @events = @events.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

    render json: @events, meta: pagination_dict(@events), each_serializer: Zensus::EventSerializer, adapter: :json
  end

  def show
    render json: @event, serializer: Zensus::EventSerializer, adapter: :json
  end

  def search
    @events = Zensus::Event.search(params[:q],
      fields: ['description^2', :date, :related_events],
      page: params[:page], 
      per_page: params[:per_page] || 30)

    render json: @events, meta: pagination_dict(@events), each_serializer: Zensus::EventSerializer, adapter: :json
  end

  def properties
    @properties = Zensus::Activity.properties
    render json: @properties
  end
end