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
    publisher_id.present? ? Zensus::Agent.find(publisher_id) : nil
  end

  def places
    place_ids.present? ? Locate::Place.find(place_ids) : []
  end

  def organization
    organization_id.present? ? Zensus::Agent.find(organization_id) : nil
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
      publisher: publisher.try(:default_name),
      serie: [serie.title, serie.abbr, serie.print_issn].join(' '),
      year: year,
      place: places.map(&:default_name).join(' '),
      tag: tag_list.join(' '),
      volume: volume,
      note: note,
      key: key,
      isbn: print_isbn,
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
      :publisher => publisher.try(:default_name),
      :year => year,
      :address => places.map(&:default_name).join('; '),
      :month => month,
      :series => serie.title,
      :volume => volume,
      :edition => edition,
      :note => note,
      :key => key,
      :isbn => print_isbn,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end
end