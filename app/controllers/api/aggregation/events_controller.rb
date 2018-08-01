class Api::Aggregation::EventsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository, class: 'Aggregation::Event'
  
  def index
    render json: @events
  end
  def index
    @events = @events.paginate(page: params[:page], per_page: params[:per_page] || 30)
    render json: @events, meta: pagination_dict(@events), each_serializer: Aggregation::EventSerializer, adapter: :json
  end

  def show
    render json: @event, serializer: Aggregation::EventSerializer, adapter: :json
  end

  def create
    # Create a new event.
    if @event.save
      render status: :created, json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end



end