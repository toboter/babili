# t.integer  :repository_id
# t.integer  :pref_identifier_id #()
# t.string   :type # Artifact, Literature, Archival

# Item hat keinen Type. Item ist das Object, was in einem repo existiert und sich identifiern bedient. 
# Die eigentlichen Daten und Formate befinden sich im Commit.

#todo: remove type column

# RepoItem, das eigentlich item befindet sich zwischen identifier und diesem.
class Aggregation::Item < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :scoped, :scope => :repository

  TYPES = %w(CustomResource DocumentationResource ExcavatedResource)

  # belongs_to :repository
  belongs_to :pref_identifier, class_name: 'Aggregation::Identifier'
  has_and_belongs_to_many :identifiers, join_table: "aggregation_identifications", foreign_key: :item_id
  has_many :commits, dependent: :destroy
  has_many :commit_events, through: :commits, class_name: 'Aggregation::Event', source: :event
  has_many :repositories, through: :commit_events
  def repository # The Item has_one repository through multiple commit events. The Event belongs to the repo. It's no direct assocciation.
    repositories.uniq.first
  end

  validates :pref_identifier_id, uniqueness: { scope: :repository_id,
    message: "only one item" }

  def name
    pref_identifier.name
  end

  # validates repository
  # !Aggregation::Item.left_joins(:repositories).where(repositories: {id: nil}).exists?

end