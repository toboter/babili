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

  def collection=(id)
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
      :note => note,
      :key => key,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; '),
      :booktitle => collection.title,
      :editor => collection.editors.map{ |a| a.name(reverse: true) }.join(' and '),
      :publisher => publisher.try(:default_name),
      :year => year,
      :address => places.map(&:default_name).join(', '),
      :series => serie.try(:title),
      :volume => volume,
      :organization => organization.try(:name)
    })
  end
end