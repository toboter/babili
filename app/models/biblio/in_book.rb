# inbook entry
# A part of a book, which may be a chapter and/or a range of pages.
# 
# Format:
# 
#      @INBOOK{citation_key,
#              required_fields [, optional_fields] }
# Required fields: author ~~or editor~~, title, chapter and/or pages, publisher, year
# 
# Optional fields: volume, series, address, edition, month, note, key

class Biblio::InBook < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :chapter, :string
  json_attribute :pages, :string
  belongs_to :book, class_name: 'Biblio::Book', foreign_key: :parent_id

  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :book, presence: true

  delegate :year, :publisher, :places, :serie, :volume, to: :book

end