# inproceedings entry
# An article in the proceedings of a conference.
# 
# Format:
# 
#      @INPROCEEDINGS{citation_key,
#                     required_fields [, optional_fields] }
# Required fields: author, title, booktitle, year
# 
# Optional fields: editor, pages, organization, publisher, address, month, note, key

class Biblio::InProceeding < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'An article in the proceedings of a conference.'
  def fields
    [:author_ids, :title, :proceeding_id, :pages, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'file'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  belongs_to :proceeding, class_name: 'Biblio::Proceeding', foreign_key: :parent_id

  attr_json :pages, :string
  attr_json :note, :string
  attr_json :key, :string

  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

  validates :authors, :title, :proceeding, presence: true

  delegate :editors, :year, :publisher, :places, :serie, :volume, :organization, :month, to: :proceeding

  def proceeding_id=(id)
    self.parent_id = id
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      booktitle: proceeding.title,
      editor: editors.map(&:name).join(' '),
      publisher: publisher.name,
      address: places.map(&:given).join(' '),
      series: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].join(' '),
      year: year,
      tag: tag_list.join(' '),
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
      :note => note,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; '),
      :booktitle => proceeding.try(:title),
      :editor => proceeding.creators_name_list.map{ |a| a.name(reverse: true) }.join(' and '),
      :publisher => publisher.try(:name),
      :year => year,
      :address => places.map(&:given).join('; '),
      :series => serie.try(:title),
      :volume => volume,
      :organization => organization.try(:name)
    })
  end

  def self.from_bib(bibtex, creator, entries)
    if bibtex.respond_to?(:crossref) && bibtex.crossref.present?
      proceeding = entries.select{|e| e.type == 'Biblio::Proceeding' && e.data['key'] == bibtex.crossref}.first
    elsif bibtex.respond_to?(:editor) && bibtex.respond_to?(:year) && bibtex.respond_to?(:booktitle)
      proceeding = Biblio::Proceeding.with_creators(bibtex.editor).jsonb_contains(year: bibtex.year, title: bibtex.booktitle).first || Biblio::Proceeding.new
      if proceeding.new_record?
        bibtex.publisher = bibtex.publisher.presence || 'unknown'
        bibtex.editor.each do |e|
          editor = Zensus::Appellation.find_by_name(e).first || Zensus::Appellation.create(name: e)
          proceeding.editors << editor
        end
        proceeding.title = bibtex.booktitle.strip if bibtex.try(:booktitle)
        proceeding.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id if bibtex.try(:publisher)
        proceeding.year = bibtex.year
        proceeding.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
        proceeding.month = bibtex.try(:month)
        proceeding.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
        proceeding.volume = bibtex.try(:volume)
        proceeding.organization_id = Zensus::Appellation.find_by_name(bibtex.organization).first.try(:id) || Zensus::Appellation.create(name: bibtex.organization).id if bibtex.try(:organization)
        proceeding.print_isbn = bibtex.try(:isbn)
        proceeding.creator = creator
      end
    end
    return nil unless proceeding.valid?

    obj = self.with_creators(bibtex.author).where(parent_id: proceeding.try(:id)).jsonb_contains(title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title.strip if bibtex.try(:title)
      obj.proceeding = entries.map{|e| e.proceeding if e.respond_to?(:proceeding) }.select{ |c| c.editors == proceeding.editors && c.title == proceeding.title && c.year == proceeding.year }.first || proceeding
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