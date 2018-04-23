# mastersthesis entry
# A Master's thesis.
# 
# Format:
# 
#      @MASTERSTHESIS{citation_key,
#                     required_fields [, optional_fields] }
# Required fields: author, title, school, year
# 
# Optional fields: address, month, note, key

class Biblio::Masterthesis < Biblio::Entry
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = "A Master's thesis."
  def icon
    'book'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :school_id, :integer
  json_attribute :year, :string

  json_attribute :place_ids, :integer, array: true
  json_attribute :month, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  validates :authors, :title, :school_id, :year, presence: true

  def places
    place_ids.present? ? Locate::Toponym.find(place_ids) : []
  end

  def school
    school_id.present? ? Zensus::Appellation.find(school_id) : nil
  end

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      note: note,
      year: year,
      tag: tag_list.join(' '),
      url: url,
      doi: doi,
      abstract: abstract,
      address: places.map(&:given).join('; '),
      school: school.try(:name)
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :author => authors.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :year => year,
      :month => month,
      :address => places.map(&:given).join('; '),
      :school => school.try(:name),
      :note => note,
      :url => url,
      :doi => doi,
      :abstract => abstract,
      :keywords => tag_list.join('; ')
    })
  end

  def self.from_bib(bibtex, creator)
    obj = self.with_creators(bibtex.author).jsonb_contains(title: bibtex.title).first || self.new
    obj.key = bibtex.key
    if obj.new_record?
      bibtex.author.each do |a|
        author = Zensus::Appellation.find_by_name(a).first || Zensus::Appellation.create(name: a)
        obj.authors << author
      end if bibtex.try(:author)
      obj.title = bibtex.title.strip if bibtex.try(:title)
      obj.year = bibtex.try(:year)
      obj.month = bibtex.try(:month)
      obj.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
      obj.school_id = Zensus::Appellation.find_by_name(bibtex.school).first.try(:id) || Zensus::Appellation.create(name: bibtex.school).id if bibtex.try(:school)
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