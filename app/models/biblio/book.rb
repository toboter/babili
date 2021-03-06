# book entry -- a monograph
# A book with an explicit publisher.
# 
# Format:
# 
#      @BOOK{citation_key,
#            required_fields [, optional_fields] }
# Required fields: author ~~or editor~~, title, publisher, year
# 
# Optional fields: volume, series, address, edition, month, note, key

class Biblio::Book < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A book with an author and explicit publisher.'
  def fields
    [:author_ids, :title, :publisher_id, :year, :month, :serie, :volume, :number, :place_ids, :organization_id, :edition, :print_isbn, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'book'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, -> { order 'biblio_creatorships.id asc' }, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  attr_json :publisher_id, :integer
  attr_json :year, :string

  attr_json :volume, :string
  attr_json :number, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true

  attr_json :place_ids, :integer, array: true
  attr_json :organization_id, :integer
  attr_json :edition, :string
  attr_json :month, :string
  attr_json :note, :string
  attr_json :key, :string

  attr_json :print_isbn, :string
  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

  validates :authors, :title, :publisher_id, :year, presence: true

  def publisher
    publisher_id.present? ? Zensus::Appellation.find(publisher_id) : nil
  end

  def places
    place_ids.any? ? Locate::Toponym.find(place_ids) : []
  end

  def organization
    organization_id.present? ? Zensus::Appellation.find(organization_id) : nil
  end

  has_many :in_books, class_name: 'Biblio::InBook', foreign_key: :parent_id

  accepts_nested_attributes_for :serie, reject_if: :all_blank, allow_destroy: false

  def serie=(id)
    self.parent_id = id
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name),
      title: title,
      publisher: publisher.try(:name),
      series: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].compact,
      year: year,
      address: places.map(&:given),
      volume: volume,
      number: number,
      note: note,
      isbn: print_isbn,
      url: url,
      doi: doi,
      abstract: abstract,
      tags: tag_list
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :author => creators_name_list.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :month => month,
      :series => serie.try(:title),
      :volume => volume,
      :number => number,
      :edition => edition,
      :note => note,
      :isbn => print_isbn,
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
      bibtex.publisher = bibtex.publisher.presence || 'unknown'
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title.strip if bibtex.title.present?
      obj.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id
      obj.year = bibtex.year
      obj.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
      obj.month = bibtex.try(:month)
      obj.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
      obj.volume = bibtex.try(:volume)
      obj.number = bibtex.try(:number)
      obj.edition = bibtex.try(:edition)
      obj.note = bibtex.try(:note)
      obj.abstract = bibtex.try(:abstract)
      obj.print_isbn = bibtex.try(:isbn)
      obj.doi = bibtex.try(:doi)
      obj.url = bibtex.try(:url)
      obj.tag_list = bibtex.try(:keywords)
      obj.creator = creator
    end
    return obj
  end

end