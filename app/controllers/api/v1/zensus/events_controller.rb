module Api::V1::Zensus
  class EventsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Zensus::Event'

    def index
      sort_order = Zensus::Event.sorted_by(params[:sort].presence || 'updated_at_desc')
      @events = @events.where("updated_at > ?", params[:since]) if params[:since]
      @pagy, @events = pagy(:offset, @events.order(sort_order), limit: (params[:per_page] || 30).to_i)

      @meta = pagination_dict(@pagy)
      render template: "api/v1/zensus/events/index"
    end

    def show
      render template: "api/v1/zensus/events/show"
    end

    def search
      @events = Zensus::Event.search(params[:q],
        fields: ['description^2', :date, :related_events],
        page: params[:page], 
        per_page: params[:per_page] || 30)

      @pagy = pagy(:searchkick, @events)
      @meta = pagination_dict(@pagy)
      render template: "api/v1/zensus/events/search"
    end

    def properties
      @properties = Zensus::Activity.properties
      render json: @properties
    end
  end
end