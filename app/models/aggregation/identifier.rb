# t.string   :origin_id
# t.string   :origin_type
# t.string   :origin_agent_id # -> wer hat die id vergeben?
# t.timestamps

class Aggregation::Identifier < ApplicationRecord
  has_and_belongs_to_many :items, join_table: "aggregation_identifications", foreign_key: :identifier_id
  has_many :items_with_pref_identifiers, class_name: 'Aggregation::Item', foreign_key: :pref_identifier_id
  has_many :others, -> (object) { where.not(id: object.id) }, through: :items, source: :identifiers
  has_many :others_items, -> (object) { where.not(id: object.items.ids) }, through: :others, source: :items

  validates :origin_id, uniqueness: { scope: :origin_type,
    message: "only one identifier" }

  def name
    "#{origin_type}-#{origin_id}"
  end
end

# Aggregation::Identifier.first.identifiers
# Aggregation::Identifier.first.identifiers.map{|i| i.items_with_pref_identifiers}