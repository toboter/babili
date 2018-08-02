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

  before_validation :set_item

  TYPES = %w(Lido Custom MediaFile)

  belongs_to :item
  belongs_to :event
  belongs_to :origin_commit_id, optional: true, class_name: 'Aggregation::Commit'
  belongs_to :creator, class_name: 'Person'

  validates :item, :event, presence: true

  def set_item
    pref_identifier = Aggregation::Identifier.where(origin_id: identifier[:id], origin_type: identifier[:type], origin_agent_id: identifier[:agent]).first_or_create  
    item = Aggregation::Item.where(pref_identifier_id: pref_identifier.id, repository_id: self.event.repository_id).first_or_create
    item.identifiers << pref_identifier unless item.identifiers.include?(pref_identifier)
    self.item = item
  end
    
end