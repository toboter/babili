class Aggregation::Event::UploadsController < Aggregation::EventsController
  # Parent loads events by :id for show/commit/destroy; upload actions manage that themselves.
  skip_before_action :load_and_authorize_aggregation_event
  before_action :authorize_repository_write!
  before_action :load_replaceable_event, only: :replace

  def new
    @event = Aggregation::Event::UploadEvent.new(repository: @repository)
    authorize! :new, @event
  end

  def create
    @event = Aggregation::Event::UploadEvent.new(event_attributes)
    @event.creator = current_person
    @event.note = @event.note.presence || default_upload_note
    authorize! :create, @event

    respond_to do |format|
      if @event.save
        attach_files!(@event)
        format.html { redirect_to namespace_repository_aggregation_event_url(@namespace, @repository, @event), notice: "Your data has been uploaded." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # Replace files on a pending / empty-commit upload event, then allow re-commit.
  def replace
    authorize! :update, @event

    if upload_files.empty?
      redirect_to namespace_repository_aggregation_event_path(@namespace, @repository, @event),
                  alert: "Choose at least one file to replace the upload."
      return
    end

    attrs = event_attributes
    @event.assign_attributes(attrs)
    @event.note = @event.note.presence || default_upload_note
    @event.commited_at = nil

    if @event.save
      @event.uploads.destroy_all
      attach_files!(@event)
      redirect_to namespace_repository_aggregation_event_path(@namespace, @repository, @event),
                  notice: "Files replaced. Review the Primary key, then click Commit data."
    else
      redirect_to namespace_repository_aggregation_event_path(@namespace, @repository, @event),
                  alert: @event.errors.full_messages.to_sentence.presence || "Could not replace files."
    end
  end

  private

  def authorize_repository_write!
    authorize! :read, @repository
  end

  def load_replaceable_event
    @event = @repository.events.friendly.find(params[:id])
    unless @event.is_a?(Aggregation::Event::UploadEvent)
      redirect_to namespace_repository_aggregation_event_path(@namespace, @repository, @event),
                  alert: "Only upload events can receive replacement files."
      return
    end
    if @event.locked? && @event.commits.any?
      redirect_to namespace_repository_aggregation_event_path(@namespace, @repository, @event),
                  alert: "This event is already committed. Start a new import to add more data."
    end
  end

  def event_attributes
    resource_params.except(:files).merge(repository: @repository)
  end

  def upload_files
    Array(resource_params[:files]).reject(&:blank?)
  end

  def attach_files!(event)
    upload_files.each { |file| event.uploads.create!(file: file) }
  end

  def default_upload_note
    names = upload_files.map { |f| f.original_filename.to_s.presence }.compact
    names.present? ? "Upload: #{names.join(', ')}" : "File upload"
  end
end
