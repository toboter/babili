# unpublished entry
# A document with an author and title, but not formally published.
# 
# Format:
# 
#      @UNPUBLISHED{citation_key,
#                   required_fields [, optional_fields] }
# Required fields: author, title, note
# 
# Optional fields: month, year, key

class Biblio::Unpublished < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A document with an author and title, but not formally published.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :note, :string

  json_attribute :month, :string
  json_attribute :year, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :note, presence: true

end