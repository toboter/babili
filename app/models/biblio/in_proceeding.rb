# inproceedings entry
# An article in the proceedings of a conference.
# 
# Format:
# 
#      @INPROCEEDINGS{citation_key,
#                     required_fields [, optional_fields] }
# Required fields: author, title, booktitle, year
# 
# Optional fields: editor, pages, organization, publisher, address, month, note, key

class Biblio::InProceeding < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'An article in the proceedings of a conference.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  belongs_to :proceeding, class_name: 'Biblio::Proceeding', foreign_key: :parent_id

  json_attribute :pages, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :proceeding, presence: true

  delegate :editors, :year, :publisher, :places, :organization, :month, to: :proceeding

end