class Aggregation::EventsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  before_action :load_and_authorize_aggregation_event, except: [:index, :new]
  layout "repositories/base"

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
    event_path = namespace_repository_aggregation_event_path(@namespace, @repository, @event)

    if @event.locked? && @event.commits.any?
      redirect_to event_path, notice: "Already processed."
      return
    end

    respond_to do |format|
      begin
        count = @event.process
        if count.to_i.zero?
          format.html {
            redirect_to event_path,
                        alert: "Nothing was committed. Use a CSV/XLSX/ODS with a header + data rows (or LIDO XML), and set Primary key to a header column name."
          }
        elsif @event.update(commited_at: Time.current)
          format.html {
            redirect_to event_path,
                        notice: "Committed #{helpers.pluralize(count, 'record')}."
          }
          format.json { render :show, status: :ok, location: event_path }
        else
          format.html { redirect_to event_path, alert: "Processed files but failed to lock the event." }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      rescue StandardError => e
        format.html {
          redirect_to event_path,
                      alert: "Commit failed: #{e.message}"
        }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    redirect_to namespace_repository_aggregation_events_path(@namespace, @repository)
  end

  private

  def load_and_authorize_aggregation_event
    @event = @repository.events.friendly.find(params[:id])
    authorize! action_name.to_sym, @event
  end

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
