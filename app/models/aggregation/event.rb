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
  friendly_id :name, :use => :scoped, :scope => :repository
  TYPES = %w(FileUpload ApiRequest ListTransform)
  attr_accessor :files

  belongs_to :repository
  belongs_to :creator, class_name: "Person"

  has_many :commits, dependent: :destroy
  has_many :items, through: :commits
  
  validates :note, :creator, :repository, presence: true

  scope :pending, -> {where(commited_at: nil)}
  scope :commited, -> {where.not(commited_at: nil)}

  def commit_items(resource_type, data)
    if !data.is_a?(Array)
      identifier = Aggregation::Identifier.where(origin_id: data[:identifier][:value], origin_type: data[:identifier][:type], origin_agent_id: data[:identifier][:source]).first_or_create
      item = Aggregation::Item.where(pref_identifier_id: identifier.id, repository_id: self.repository_id, type: resource_type).first_or_create
      item.identifiers << identifier unless item.identifiers.include?(identifier)
      data[:changeset] = item.commits.any? ? HashDiff.diff(data[:payload], JSON.parse( item.commits.last.try(:data).try(:[], 'payload').to_json, {:symbolize_names => true} )) : []
      commit = (data[:changeset].present? || item.commits.empty?) ? Aggregation::Commit.create(type: 'Aggregation::Commit::Legacy', item_id: item.id, event_id: self.id, creator_id: self.creator_id, data: data) : item.commits.last
      return commit
    elsif data.is_a?(Array)
      # data is a array. import through AcitveRecord.import
      commits = []
      data.each do |element|
        identifier = Aggregation::Identifier.where(origin_id: element[:identifier][:value], origin_type: element[:identifier][:type], origin_agent_id: element[:identifier][:source]).first_or_create
        item = Aggregation::Item.where(pref_identifier: identifier, repository_id: self.repository_id, type: resource_type).first_or_create
        item.identifiers << identifier unless item.identifiers.include?(identifier)
        element[:changeset] = item.commits.any? ? HashDiff.diff(element[:payload], item.commits.last.try(:data).try(:[], 'payload')) : []
        commit = Aggregation::Commit.new(type: 'Aggregation::Commit::Legacy', item_id: item.id, event_id: self.id, creator_id: self.creator_id, data: element)
        commits << commit if element[:changeset].present? || item.commits.empty?
      end
      Aggregation::Commit.import commits
    end
  end

  def locked?
    commited_at.present?
  end

  def name
    Time.now.to_formatted_s(:iso8601) 
  end

end