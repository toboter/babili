class Aggregation::Item::VersionsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_resource :item, class: "Aggregation::Item", through: :repository
  before_action :authorize_item_read!
  layout "repositories/base"

  def create
    @event = Aggregation::Event::UploadEvent.new(
      repository: @repository,
      creator: current_person,
      primary_id_label: version_primary_id_label,
      note: version_note
    )
    authorize! :create, @event

    files = upload_files
    if files.empty?
      redirect_to item_path,
                  alert: "Choose a CSV/XLSX/ODS file that includes a row for this item."
      return
    end

    @event.save!
    files.each { |file| @event.uploads.create!(file: file) }

    count = @event.process_version_for!(@item)
    if count.to_i.zero?
      @event.update!(commited_at: Time.current)
      redirect_to item_path,
                  notice: "No changes detected for this item (payload identical to the latest version)."
    elsif @event.update(commited_at: Time.current)
      redirect_to item_path,
                  notice: "Added #{helpers.pluralize(count, 'new version')}."
    else
      redirect_to item_path, alert: "Version processed but failed to lock the event."
    end
  rescue StandardError => e
    redirect_to item_path, alert: "Could not add version: #{e.message}"
  end

  private

  def authorize_item_read!
    authorize! :show, @item
  end

  def item_path
    namespace_repository_aggregation_item_path(@namespace, @repository, @item)
  end

  def upload_files
    Array(params.dig(:aggregation_event, :files)).reject(&:blank?)
  end

  def version_note
    params.dig(:aggregation_event, :note).presence || "Version for #{@item.name}"
  end

  def version_primary_id_label
    params.dig(:aggregation_event, :primary_id_label).presence ||
      @item.identifier.origin_type
  end
end
