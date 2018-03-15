class Api::Aggregation::EventsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository, class: 'Aggregation::Event'
  
  def index
    render json: @events
  end

  def show
    render json: @event
  end

  def create
    # Create a new event.
    if @event.save
      render status: :created, json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def commit
    # commit the new items from origin, by processing to the repo.
  end



end