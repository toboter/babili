class Biblio::Serie < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Editor)
  DESCRIPTION = 'A sequence of books having certain characteristics in common.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :editors, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  attr_json :abbr, :string
  attr_json :note, :string
  attr_json :key, :string
  attr_json :year, :string
  attr_json :print_issn, :string

  validates :title, presence: true
  def icon
    'files'
  end

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