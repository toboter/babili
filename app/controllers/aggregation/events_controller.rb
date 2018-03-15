class Aggregation::EventsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource :events, through: :repository, class: 'Aggregation::Event'
  layout 'repo'
  
  def index
  end

  def show
    raise @event.inspect
  end

  def new
  end

  def edit
  end

  def create
    @event.creator = current_person
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to [@namespace, @repository], notice: 'Commit event updated.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def commit
  end

  private
  def event_params
    params.require(:aggregation_event).permit(
      :note,
      :type,
      :origin,
      :processors
    )
  end
end