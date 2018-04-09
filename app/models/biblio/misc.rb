# misc entry
# Use this type when nothing else seems appropriate.
# 
# Format:
# 
#      @MISC{citation_key,
#            required_fields [, optional_fields] }
# Required fields: none
# 
# Optional fields: author, title, howpublished, month, year, note, key

class Biblio::Misc < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :howpublished, :string
  json_attribute :month, :string
  json_attribute :year, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

end