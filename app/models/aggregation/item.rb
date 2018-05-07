# t.integer  :repository_id
# t.integer  :pref_identifier_id #()
# t.string   :type # Artifact, Literature, Archival

class Aggregation::Item < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => :repository

  TYPES = %w(CustomResource DocumentationResource ExcavatedResource)

  belongs_to :repository
  belongs_to :pref_identifier, class_name: 'Aggregation::Identifier'
  has_and_belongs_to_many :identifiers, join_table: "aggregation_identifications", foreign_key: :item_id
  has_many :commits, dependent: :destroy
  has_many :commit_events, through: :commits, class_name: 'Aggregation::Event'

  validates :pref_identifier_id, uniqueness: { scope: :repository_id,
    message: "only one item" }

  def name
    "#{pref_identifier.origin_type}-#{pref_identifier.origin_id}"
  end
end