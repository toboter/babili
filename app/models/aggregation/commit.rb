# t.integer  :item_id
# t.integer  :event_id
# t.integer  :origin_commit_id
# t.integer  :creator_id
# t.string   :type
# t.jsonb    :data, default: {}
# t.timestamps

class Aggregation::Commit < ApplicationRecord
  #json_attribute :identifier
  #json_attribute :changeset
  attr_accessor :identifier

  # before_validation :set_item

  TYPES = %w(Lido Custom MediaFile)

  belongs_to :item
  belongs_to :event
  belongs_to :origin_commit_id, optional: true, class_name: 'Aggregation::Commit'
  belongs_to :creator, class_name: 'Person'

  validates :item, :event, presence: true

  def payload
    return {} unless data.is_a?(Hash)

    data["payload"] || data[:payload] || {}
  end

  def columns
    return [] unless data.is_a?(Hash)

    stored = Array(data["columns"] || data[:columns]).map(&:to_s)
    return stored if stored.any?

    inferred_columns_from_event_upload
  end

  def identifier_data
    return {} unless data.is_a?(Hash)

    data["identifier"] || data[:identifier] || {}
  end

  def changeset
    return [] unless data.is_a?(Hash)

    data["changeset"] || data[:changeset] || []
  end

  def identifier_label
    id = identifier_data
    value = id["value"] || id[:value]
    type = id["type"] || id[:type]
    [type, value].compact.join(": ").presence || item&.name
  end

  # Payload pairs in spreadsheet column order when columns were stored.
  def ordered_payload_pairs
    source = payload
    return [] if source.blank?

    keyed = source.each_with_object({}) { |(k, v), memo| memo[k.to_s] = v }
    order = columns.presence || keyed.keys
    seen = []
    pairs = order.filter_map do |key|
      next unless keyed.key?(key)

      seen << key
      [key, keyed[key]]
    end
    extras = keyed.reject { |k, _| seen.include?(k) }.to_a
    pairs + extras
  end

  def tabular_payload?
    payload.present? && payload.values.all? { |v| scalar_payload_value?(v) }
  end

  def payload_preview(limit: 4)
    ordered_payload_pairs.first(limit).map { |k, v| "#{k}: #{v.to_s.truncate(40)}" }
  end

  def set_item
    raise identifier.inspect
    pref_identifier = Aggregation::Identifier.where(origin_id: identifier[:id], origin_type: identifier[:type], origin_agent_id: identifier[:agent]).first_or_create
    item = Aggregation::Item.where(pref_identifier_id: pref_identifier.id, repository_id: self.event.repository_id).first_or_create
    item.identifiers << pref_identifier unless item.identifiers.include?(pref_identifier)
    self.item = item
  end

  private

  def scalar_payload_value?(value)
    value.nil? || value.is_a?(String) || value.is_a?(Numeric) || value == true || value == false
  end

  # Best-effort recovery for commits saved before columns were persisted.
  def inferred_columns_from_event_upload
    return [] unless event.is_a?(Aggregation::Event::UploadEvent)
    return [] unless event.respond_to?(:uploads)

    upload = event.uploads.detect do |u|
      name = u.file&.data&.dig("metadata", "filename").to_s.downcase
      name.end_with?(".csv", ".xlsx", ".ods")
    end
    return [] unless upload&.file

    require "roo" unless defined?(Roo)
    downloaded = upload.file.download
    path = downloaded.respond_to?(:path) ? downloaded.path : downloaded.to_s
    sheet = Roo::Spreadsheet.open(path)
    sheet.row(1).map { |h| h.to_s.strip.underscore.presence }.compact
  rescue StandardError
    []
  end
end
