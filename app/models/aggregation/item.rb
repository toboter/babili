# t.integer  :repository_id
# t.integer  :pref_identifier_id #()
# t.string   :type # Artifact, Literature, Archival

class Aggregation::Item < ApplicationRecord
  TYPES = %w(CustomResource DocumentationResource ExcavatedResource BibliographicResource)

  belongs_to :pref_identifier, class_name: 'Aggregation::Identifier'
  has_and_belongs_to_many :identifiers, join_table: "aggregation_identifications"
  has_many :commits, dependent: :destroy
  has_many :commit_events, through: :commits, class_name: 'Aggregation::Event'
  has_many :repositories, through: :commit_events

end