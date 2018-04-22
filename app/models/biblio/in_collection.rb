# incollection entry
# A part of a book with its own title.
# 
# Format:
# 
#      @INCOLLECTION{citation_key,
#                    required_fields [, optional_fields] }
# Required fields: author, title, booktitle, year
# 
# Optional fields: editor, pages, organization, publisher, address, month, note, key

class Biblio::InCollection < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A part of a book with its own title.'

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  belongs_to :collection, class_name: 'Biblio::Collection', foreign_key: :parent_id

  json_attribute :pages, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :collection, presence: true

  delegate :editors, :year, :month, :publisher, :places, :serie, :volume, :organization, to: :collection

  def collection_id=(id)
    self.parent_id = id
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      book: collection.search_data,
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
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :pages => pages,
      :note => note,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; '),
      :booktitle => collection.title,
      :editor => collection.editors.map{ |a| a.name(reverse: true) }.join(' and '),
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
      collection = entries.select{|e| e.type == 'Biblio::Collection' && e.data['key'] == bibtex.crossref}.first
    elsif bibtex.respond_to?(:editor) && bibtex.respond_to?(:year) && bibtex.respond_to?(:booktitle)
      collection = Biblio::Collection.with_creators(bibtex.editor).jsonb_contains(year: bibtex.year, title: bibtex.booktitle).first || Biblio::Collection.new
      if collection.new_record?
        bibtex.publisher = bibtex.publisher.presence || 'anonymous'
        bibtex.editor.each do |e|
          editor = Zensus::Appellation.find_by_name(e).first || Zensus::Appellation.create(name: e)
          collection.editors << editor
        end
        collection.title = bibtex.booktitle
        collection.publisher_id = Zensus::Appellation.find_by_name(bibtex.publisher).first.try(:id) || Zensus::Appellation.create(name: bibtex.publisher).id if bibtex.publisher.present?
        collection.year = bibtex.year
        collection.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
        collection.month = bibtex.try(:month)
        collection.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id
        collection.volume = bibtex.try(:volume)
        collection.edition = bibtex.try(:edition)
        collection.print_isbn = bibtex.try(:isbn)
        collection.creator = creator
      end
    end
    return nil unless collection.valid?

    obj = self.with_creators(bibtex.author).where(parent_id: collection.try(:id)).jsonb_contains(title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end
      obj.title = bibtex.title
      obj.collection = entries.map{|e| e.collection if e.respond_to?(:collection) }.select{ |c| c.try(:editors) == collection.try(:editors) && c.title == collection.title && c.year == collection.year }.first || collection
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