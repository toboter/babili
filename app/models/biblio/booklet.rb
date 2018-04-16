# booklet entry
# A work that is printed and bound, but without a named publisher or sponsoring institution.
# 
# Format:
# 
#      @BOOKLET{citation_key,
#               required_fields [, optional_fields] }
# Required fields: title
# 
# Optional fields: author, howpublished, address, month, year, note, key

class Biblio::Booklet < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A work that is printed and bound, but without a named publisher or sponsoring institution.'

  json_attribute :title, :string

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :howpublished, :string
  json_attribute :place_ids, :integer, array: true
  json_attribute :month, :string
  json_attribute :year, :string
  json_attribute :note, :string
  json_attribute :key, :string

  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :title, presence: true

  def places
    Locate::Place.find(self.place_ids)
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      year: year,
      place: places.map(&:default_name).join(' '),
      tag: tag_list.join(' '),
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
      :bibtex_key => citation,
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :howpublished => howpublished,
      :year => year,
      :address => places.map(&:default_name).join('; '),
      :month => month,
      :note => note,
      :key => key,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end
end