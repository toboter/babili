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
  DESCRIPTION = 'A part of a book, which may be a chapter and/or a range of pages.'
  def fields
    [:author_ids, :title, :book_id, :chapter, :pages, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'file'
  end

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

  delegate :year, :month, :publisher, :places, :serie, :volume, to: :book

  def book_id=(id)
    self.parent_id = id
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      booktitle: book.title,
      publisher: publisher.name,
      address: places.map(&:given).join(' '),
      series: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].join(' '),
      year: year,
      tag: tag_list.join(' '),
      chapter: chapter,
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
      :pages => pages,
      :chapter => chapter,
      :note => note,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; '),
      :booktitle => book.title,
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :series => serie.try(:title),
      :volume => volume
    })
  end

  def self.from_bib(bibtex, creator, entries)
    if bibtex.respond_to?(:crossref) && bibtex.crossref.present?
      book = entries.select{|e| e.type == 'Biblio::Book' && e.data['key'] == bibtex.crossref}.first
    elsif bibtex.respond_to?(:author) && bibtex.respond_to?(:year) && (bibtex.respond_to?(:booktitle) || bibtex.respond_to?(:title))
      book = Biblio::Book.with_creators(bibtex.author).jsonb_contains(year: bibtex.year, title: (bibtex.try(:booktitle) ? bibtex.booktitle : bibtex.title)).first || Biblio::Book.new
      if book.new_record?
        bibtex.publisher = bibtex.publisher.presence || 'unknown'
        bibtex.author.each do |e|
          author = Zensus::Appellation.find_by_name(e).first || Zensus::Appellation.create(name: e)
          book.authors << author
        end
        book.title = bibtex.try(:booktitle) ? bibtex.booktitle.strip : bibtex.title.strip
        book.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id if bibtex.publisher.present?
        book.year = bibtex.year
        book.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a }
        book.month = bibtex.try(:month)
        book.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
        book.volume = bibtex.try(:volume)
        book.edition = bibtex.try(:edition)
        book.print_isbn = bibtex.try(:isbn)
        book.creator = creator
      end
    end
    return nil unless book.valid?

    obj = self.with_creators(bibtex.author).where(parent_id: book.try(:id)).jsonb_contains(title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title.strip if bibtex.title.present?
      obj.book = entries.map{|e| e.book if e.respond_to?(:book) }.select{ |c| c.authors == book.authors && c.title == book.title && c.year == book.year }.first || book
      obj.pages = bibtex.try(:pages)
      obj.chapter = bibtex.try(:chapter)
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