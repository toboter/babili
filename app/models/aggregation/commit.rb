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

  TYPES = %w(Lido Custom MediaFile)

  belongs_to :item
  belongs_to :event
  belongs_to :origin_commit_id, optional: true, class_name: 'Aggregation::Commit'
  belongs_to :creator, class_name: 'Person'
  
    
end