module Api::V1::Zensus
  class EventsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Zensus::Event'

    def index
      sort_order = Zensus::Event.sorted_by(params[:sort].presence || 'updated_at_desc')
      @events = @events.where("updated_at > ?", params[:since]) if params[:since]
      @events = @events.paginate(page: params[:page], per_page: params[:per_page] || 30).order(sort_order)

      render_with_serializer(@events, meta: pagination_dict(@events), each_serializer: EventSerializer)
    end

    def show
      render_with_serializer(@event, serializer: EventSerializer)
    end

    def search
      @events = Zensus::Event.search(params[:q],
        fields: ['description^2', :date, :related_events],
        page: params[:page], 
        per_page: params[:per_page] || 30)

      render_with_serializer(@events, meta: pagination_dict(@events), each_serializer: EventSerializer)
    end

    def properties
      @properties = Zensus::Activity.properties
      render json: @properties
    end
  end
end