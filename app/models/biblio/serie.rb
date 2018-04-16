class Biblio::Serie < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Editor)
  DESCRIPTION = 'A sequence of books having certain characteristics in common.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :editors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :abbr, :string
  json_attribute :note, :string
  json_attribute :key, :string
  json_attribute :year, :string
  json_attribute :print_issn, :string

  validates :title, presence: true

  def serials
    children.where(type: ['Biblio::Book', 'Biblio::Collection', 'Biblio::Proceeding'])
  end
  
  def search_data
    {
      name: title,
      abbr: abbr,
      articles: serials.map(&:citation),
      issn: print_issn
    }
  end

end