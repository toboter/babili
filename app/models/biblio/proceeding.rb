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
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Editor)
  DESCRIPTION = 'The proceedings of a conference.'
  def fields
    [:editor_ids, :title, :publisher_id, :year, :month, :serie, :volume, :place_ids, :organization_id, :print_isbn, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'book'
  end

  attr_json :title, :string
  attr_json :year, :string

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :editors, through: :creatorships, source: :agent_appellation
  attr_json :publisher_id, :integer
  attr_json :organization_id, :integer
  attr_json :place_ids, :integer, array: true
  attr_json :month, :string
  attr_json :note, :string
  attr_json :key, :string

  attr_json :volume, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true

  attr_json :print_isbn, :string
  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

  validates :title, :year, presence: true

  def publisher
    publisher_id.present? ? Zensus::Appellation.find(publisher_id) : nil
  end

  def places
    place_ids.any? ? Locate::Toponym.find(place_ids) : []
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
      volume: volume,
      note: note,
      isbn: print_isbn,
      url: url,
      doi: doi,
      abstract: abstract,
      organization: organization.try(:name),
      tags: tag_list
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :editor => creators_name_list.map{ |a| a.name(reverse: true) }.join(' and '),
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