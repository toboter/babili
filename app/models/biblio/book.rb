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
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A book with an author and explicit publisher.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :publisher_id, :integer
  json_attribute :year, :string

  json_attribute :volume, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true

  json_attribute :place_ids, :integer, array: true
  json_attribute :organization_id, :integer
  json_attribute :edition, :string
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :print_isbn, :string
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :publisher_id, :year, presence: true

  def publisher
    publisher_id.present? ? Zensus::Appellation.find(publisher_id) : nil
  end

  def places
    place_ids.present? ? Locate::Toponym.find(place_ids) : []
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
      author: authors.map(&:name).join(' '),
      title: title,
      publisher: publisher.try(:name),
      serie: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].join(' '),
      year: year,
      place: places.map(&:given).join(' '),
      tag: tag_list.join(' '),
      volume: volume,
      note: note,
      isbn: print_isbn,
      url: url,
      doi: doi,
      abstract: abstract
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :month => month,
      :series => serie.try(:title),
      :volume => volume,
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
      bibtex.publisher = bibtex.publisher.presence || 'anonymous'
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title
      obj.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id
      obj.year = bibtex.year
      obj.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
      obj.month = bibtex.try(:month)
      obj.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
      obj.volume = bibtex.try(:volume)
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