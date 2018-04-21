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
      book: book.search_data,
      year: year,
      tag: tag_list.join(' '),
      chapter: chapter,
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
      :bibtex_key => bibtex_citation,
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :pages => pages,
      :chapter => chapter,
      :note => note,
      :key => key,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; '),
      :booktitle => book.title,
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :series => serie.title,
      :volume => volume
    })
  end
end