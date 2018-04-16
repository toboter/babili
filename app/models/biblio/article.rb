# article entry
# An article from a journal or magazine.
# 
# Format:
# 
#      @ARTICLE{citation_key,
#               required_fields [, optional_fields] }
# Required fields: author, title, journal, year
# 
# Optional fields: volume, number, pages, month, note, key

class Biblio::Article < Biblio::Entry
  include ActionView::Helpers::TagHelper
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'
  

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'An article from a journal or magazine.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, -> { order 'biblio_creatorships.id asc' }, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  belongs_to :journal, class_name: 'Biblio::Journal', foreign_key: :parent_id
  json_attribute :year, :string

  json_attribute :volume, :string
  json_attribute :number, :string
  json_attribute :pages, :string
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :journal, :year, presence: true
  
  def journal=(id)
    self.parent_id = id
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      journal: [journal.name, journal.abbr, journal.print_issn].join(' '),
      year: year,
      tag: tag_list.join(' '),
      volume: volume,
      number: number,
      pages: pages,
      note: note,
      key: key,
      url: url,
      doi: doi,
      abstract: abstract
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => citation,
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :journal => journal.try(:name),
      :year => year,
      :month => month,
      :volume => volume,
      :number => number,
      :pages => pages,
      :note => note,
      :key => key,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end

end