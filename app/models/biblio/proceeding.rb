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
    place_ids.present? ? Locate::Place.find(place_ids) : []
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
      publisher: publisher.try(:default_name),
      serie: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].join(' '),
      year: year,
      place: places.map(&:default_name).join(' '),
      tag: tag_list.join(' '),
      volume: volume,
      note: note,
      key: key,
      isbn: print_isbn,
      url: url,
      doi: doi,
      abstract: abstract,
      organization: organization.try(:default_name)
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :editor => editors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :publisher => publisher.try(:default_name),
      :year => year,
      :address => places.map(&:default_name).join('; '),
      :month => month,
      :series => serie.try(:title),
      :volume => volume,
      :organization => organization.try(:default_name),
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