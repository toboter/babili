# t.string   :origin_id
# t.string   :origin_type
# t.string   :origin_agent_id # -> wer hat die id vergeben?
# t.timestamps

class Aggregation::Identifier < ApplicationRecord
  has_and_belongs_to_many :items, join_table: "aggregation_identifications", foreign_key: "items_id"

end