# manual entry
# Technical documentation.
# 
# Format:
# 
#      @MANUAL{citation_key,
#              required_fields [, optional_fields] }
# Required fields: title
# 
# Optional fields: author, organization, address, edition, month, year, note, key

class Biblio::Manual < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'Technical documentation.'

  json_attribute :title, :string

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :organization_id, :integer
  json_attribute :place_ids, :integer, array: true
  json_attribute :edition, :string
  json_attribute :month, :string
  json_attribute :year, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :title, presence: true

  def places
    place_ids.present? ? Locate::Place.find(place_ids) : []
  end

  def organization
    organization_id.present? ? Zensus::Appellation.find(organization_id) : nil
  end

end