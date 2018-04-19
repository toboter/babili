# mastersthesis entry
# A Master's thesis.
# 
# Format:
# 
#      @MASTERSTHESIS{citation_key,
#                     required_fields [, optional_fields] }
# Required fields: author, title, school, year
# 
# Optional fields: address, month, note, key

class Biblio::Masterthesis < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = "A Master's thesis."

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :school_id, :integer
  json_attribute :year, :string

  json_attribute :place_ids, :integer, array: true
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :school_id, :year, presence: true

  def places
    place_ids.present? ? Locate::Place.find(place_ids) : []
  end

  def school
    school_id.present? ? Zensus::Appellation.find(school_id) : nil
  end

end