# proceedings entry
# The proceedings of a conference.
# 
# Format:
# 
#      @PROCEEDINGS{citation_key,
#                   required_fields [, optional_fields] }
# Required fields: title, year
# 
# Optional fields: editor, publisher, organization, address, month, note, key

class Biblio::Proceeding < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Editor)
  DESCRIPTION = 'The proceedings of a conference.'
  def icon
    'book'
  end

  json_attribute :title, :string
  json_attribute :year, :string

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :editors, through: :creatorships, source: :agent_appellation
  json_attribute :publisher_id, :integer
  json_attribute :organization_id, :integer
  json_attribute :place_ids, :integer, array: true
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :volume, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true

  json_attribute :print_isbn, :string
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :title, :year, presence: true

  def publisher
    publisher_id.present? ? Zensus::Appellation.find(publisher_id) : nil
  end

  def places
    place_ids.present? ? Locate::Toponym.find(place_ids) : []
  end

  def organization
    organization_id.present? ? Zensus::Appellation.find(organization_id) : nil
  end

  has_many :in_proceedings, class_name: 'Biblio::InProceeding', foreign_key: :parent_id

  accepts_nested_attributes_for :serie, reject_if: :all_blank, allow_destroy: false

  def serie=(id)
    self.parent_id = id
  end
  
  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: editors.map(&:name).join(' '),
      title: title,
      publisher: publisher.try(:name),
      series: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].join(' '),
      year: year,
      address: places.map(&:given).join('; '),
      tag: tag_list.join(' '),
      volume: volume,
      note: note,
      isbn: print_isbn,
      url: url,
      doi: doi,
      abstract: abstract,
      organization: organization.try(:name)
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :editor => editors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :month => month,
      :series => serie.try(:title),
      :volume => volume,
      :organization => organization.try(:name),
      :note => note,
      :isbn => print_isbn,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end

  def self.from_bib(bibtex, creator)
    obj = self.with_creators(bibtex.editor).jsonb_contains(year: bibtex.year, title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.publisher = bibtex.publisher.presence || 'unknown'
      bibtex.editor.each do |e|
        editor = Zensus::Appellation.find_by_name(e).first || Zensus::Appellation.create(name: e)
        obj.editors << editor
      end
      obj.title = bibtex.title.strip if bibtex.try(:title)
      obj.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id if bibtex.try(:publisher)
      obj.organization_id = Zensus::Appellation.find_by_name(bibtex.organization).first.try(:id) || Zensus::Appellation.create(name: bibtex.organization).id if bibtex.try(:organization)
      obj.year = bibtex.year
      obj.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
      obj.month = bibtex.try(:month)
      obj.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
      obj.volume = bibtex.try(:volume)
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