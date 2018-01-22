class Zensus::ActivitiesController < ApplicationController
  load_and_authorize_resource :event
  load_and_authorize_resource through: :event

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @activity.save
        format.html { redirect_to zensus_event_activity_path(@event, @activity), notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to zensus_event_activity_path(@event, @activity), notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to zensus_event_activities_path(@event), notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private

  def activity_params
    params.require(:zensus_activity).permit(
      :actable_id,
      :actable_type,
      :property_id,
      :event_id,
      :note,
      :note_type,
      event_attributes: [
        :id,
        :type,
        :beginn,
        :end,
        :circa,
        :_destroy,
        event_relations_attributes: [
          :id,
          :property_id,
          :related_event_id,
          :_destroy
        ]
      ]
    )
  end
end