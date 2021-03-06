class Zensus::EventsController < ApplicationController
  load_and_authorize_resource

  def index
    set_meta_tags title: 'Events | Zensus',
                  description: "Listing events from Zensus",
                  noindex: true,
                  follow: true
    respond_to do |format|
      format.html
      format.json  { render json: @events, include: :activities, methods: [:description, :default_date] }
    end
  end

  def show
    set_meta_tags title: "#{@event.title} | Events | Zensus",
                  description: "Detail view for #{@event.type.demodulize.downcase}",
                  index: true,
                  follow: true
  end

  def new
    set_meta_tags title: "New | Events | Zensus"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    set_meta_tags title: "Edit | Events | Zensus"
  end

  def create
    @event.creator = current_person
    respond_to do |format|
      if @event.save
        format.html { redirect_to zensus_event_url(@event), notice: 'Event was successfully created.' }
        format.json { render json: @event, methods: [:description, :default_date] }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to zensus_event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to zensus_events_path, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def event_params
    params.require(:zensus_event).permit(
      :type, 
      :begins_at_string,
      :ends_at_string,
      :circa,
      :place_id,
      :period_id,
      activities_attributes: [
        :id,
        :actable_gid,
        :property_id,
        :note,
        :note_type,
        :_destroy
      ],
      event_relations_attributes: [
        :id,
        :property_id,
        :related_event_id,
        :_destroy
      ]
    )
  end
end