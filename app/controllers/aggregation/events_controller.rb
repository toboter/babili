class Aggregation::EventsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository
  layout 'repositories/base'
  
  # vererbt an FileUpload, ListTransfer, ApiRequest
  def index
    @events = @events.order(updated_at: :desc)
  end

  def show
  end

  def commit
    respond_to do |format|
      if @event.locked? 
        format.html { redirect_to [@namespace, @repository], notice: "Already processed." }
      elsif @event.process && @event.update(commited_at: Time.now)
        format.html { redirect_to [@namespace, @repository], notice: "Your upload was successfuly processed." }
        format.json { render :show, status: :ok, location: [@namespace, @repository, :aggregation, @event] }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    redirect_to namespace_repository_aggregation_events_path(@namespace, @repository)
  end

  private
  def resource_params
    params.require(:aggregation_event).permit(
      :content_type,
      :schema,
      :primary_id_label,
      :other_identificator_labels,
      :note,
      :description,
      files: []
    )
  end
end