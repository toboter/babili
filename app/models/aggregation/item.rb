# t.integer  :repository_id
# t.integer  :pref_identifier_id #()
# t.string   :type # Artifact, Literature, Archival

class Aggregation::Item < ApplicationRecord
  TYPES = %w(ArchivalResource ArtifactResource LiteratureResource)

  belongs_to :repository
  belongs_to :pref_identifier_id, class_name: 'Identifiers'
  has_and_belongs_to_many :identifiers, join_table: "aggregation_identifications", foreign_key: "identifiers_id"
  has_many :commits, dependent: :destroy
  has_many :commit_events, through: :commits, class_name: 'Aggregation::Event'

end