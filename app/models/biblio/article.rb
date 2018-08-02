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
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)
  
  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'An article from a journal or magazine.'
  def fields
    [:author_ids, :title, :year, :month, :journal, :volume, :number, :pages, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'file'
  end

  has_many :authors, -> { order 'biblio_creatorships.id asc' }, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  belongs_to :journal, class_name: 'Biblio::Journal', foreign_key: :parent_id
  attr_json :year, :string

  attr_json :volume, :string
  attr_json :number, :string
  attr_json :pages, :string
  attr_json :month, :string
  attr_json :note, :string
  attr_json :key, :string

  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

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
      url: url,
      doi: doi,
      abstract: abstract
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :author => creators_name_list.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :journal => journal.try(:name),
      :year => year,
      :month => month,
      :volume => volume,
      :number => number,
      :pages => pages,
      :note => note,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end

  def self.from_bib(bibtex, creator)
    obj = self.with_creators(bibtex.author).jsonb_contains(year: bibtex.year, title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title.strip if bibtex.title.present?
      obj.year = bibtex.year
      obj.month = bibtex.try(:month)
      obj.journal = Biblio::Journal.jsonb_contains(name: bibtex.journal).first.try(:id) || Biblio::Journal.create(name: bibtex.journal, print_issn: bibtex.try(:issn)).id
      obj.volume = bibtex.try(:volume)
      obj.number = bibtex.try(:number)
      obj.pages = bibtex.try(:pages)
      obj.note = bibtex.try(:note)
      obj.abstract = bibtex.try(:abstract)
      obj.doi = bibtex.try(:doi)
      obj.url = bibtex.try(:url)
      obj.tag_list = bibtex.try(:keywords)
      obj.creator = creator
    end
    return obj
  end

end