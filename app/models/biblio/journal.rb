class Biblio::Journal < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w()
  DESCRIPTION = 'A scientific or academic journal.'

  attr_json :name, :string
  attr_json :abbr, :string
  attr_json :key, :string
  attr_json :note, :string
  attr_json :year, :string
  attr_json :print_issn, :string
  attr_json :url, :string

  validates :name, presence: true

  has_many :articles, class_name: 'Biblio::Article', foreign_key: :parent_id

  def name_abbr
    "#{name} #{abbr ? '('+abbr+')' : ''}"
  end

  def search_data
    {
      name: name,
      abbr: abbr,
      articles: articles.map(&:citation),
      issn: print_issn
    }
  end

end
