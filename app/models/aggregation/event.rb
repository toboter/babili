# t.integer  :repository_id
# t.integer  :creator_id
# t.text     :note
# t.string   :type   # upload, api_request, list
# t.jsonb    :origin # file_data, content_type, schema(lido, table); http_request_url; list_id
# # es muss ja irgendwie sichergestellt werden dass am ende json importiert wird, 
# # vielleicht sogar nach einem zu definierende Standard. Array, weil eine Kette 
# # an zu durchlaufenden Prozessen zu erwarten ist. Bsp.: LIDO.xml to json, mapping xy.
# # saved procedures? user definded mappings?
# t.jsonb    :processors # primary_id_label || id, other_identificator_labels [], 
# t.datetime :commited_at # if present?: locked.
# t.timestamps

class Aggregation::Event < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_name, :use => :scoped, :scope => :repository
  TYPES = %w(FileUpload ApiRequest ListTransform)
  attr_accessor :files

  belongs_to :repository
  belongs_to :creator, class_name: "Person"

  has_many :commits, dependent: :destroy
  has_many :items, through: :commits
  
  validates :note, :creator, :repository, presence: true

  scope :pending, -> {where(commited_at: nil)}
  scope :commited, -> {where.not(commited_at: nil)}

  accepts_nested_attributes_for :commits, allow_destroy: false

  # Returns number of commits created/kept for this event.
  def commit_items(data)
    rows = Array.wrap(data)
    created = 0

    rows.each do |element|
      element = element.deep_symbolize_keys
      identifier_value = element.dig(:identifier, :value).presence
      next if identifier_value.blank?

      identifier = Aggregation::Identifier.where(
        origin_id: identifier_value.to_s,
        origin_type: element.dig(:identifier, :type).presence || "id",
        origin_agent_id: element.dig(:identifier, :source).presence || creator.name
      ).first_or_create!

      item = Aggregation::Item.where(
        pref_identifier_id: identifier.id,
        repository_id: repository_id
      ).first_or_create!
      item.identifiers << identifier unless item.identifiers.include?(identifier)

      created += 1 if create_commit_for_item!(item, element)
    end

    created
  end

  # Attach version commits to an existing item only (no new items created).
  def commit_version_for!(item, data)
    target = item.identifier.origin_id.to_s
    created = 0

    Array.wrap(data).each do |element|
      element = element.deep_symbolize_keys
      value = element.dig(:identifier, :value).to_s
      next if value.blank? || value != target

      element[:identifier] = {
        value: item.identifier.origin_id,
        type: item.identifier.origin_type,
        source: item.identifier.origin_agent_id,
        label: item.identifier.origin_type.to_s.camelize
      }

      created += 1 if create_commit_for_item!(item, element)
    end

    created
  end

  def locked?
    commited_at.present?
  end

  def processed_without_commits?
    locked? && commits.none?
  end

  def slug_name
    Time.now.to_fs(:iso8601)
  end

  private

  def create_commit_for_item!(item, element)
    previous_payload = item.commits.order(:id).last&.payload
    new_payload = element[:payload] || {}
    changeset =
      if previous_payload.present?
        ::Hashdiff.diff(new_payload, previous_payload)
      else
        []
      end
    element[:changeset] = changeset

    return false if changeset.blank? && item.commits.any?

    Aggregation::Commit.create!(
      type: "Aggregation::Commit::Legacy",
      item_id: item.id,
      event_id: id,
      creator_id: creator_id,
      data: element
    )
    true
  end
end
