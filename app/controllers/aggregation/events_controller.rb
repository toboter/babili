class Aggregation::EventsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :event, through: :repository, except: [:index, :new]
  layout 'repositories/base'
  
  # vererbt an FileUpload, ListTransfer, ApiRequest
  def index
    set_meta_tags title: "Data events | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Listing data events for #{@repository.name_tree.reverse.join(' | ')}",
                  noindex: true,
                  follow: true
    @events = @repository.events.accessible_by(current_ability).order(updated_at: :desc)
  end

  def show
    set_meta_tags title: "#{@event.slug} | Data events | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Listing data events for #{@repository.name_tree.reverse.join(' | ')}",
                  index: true,
                  follow: true
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