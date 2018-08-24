# techreport entry
# A report published by a school or other institution, usually numbered within a series.
# 
# Format:
# 
#      @TECHREPORT{citation_key,
#                  required_fields [, optional_fields] }
# Required fields: author, title, institution, year
# 
# Optional fields: type, number, address, month, note, key

class Biblio::Techreport < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'A report published by a school or other institution, usually numbered within a series.'
  def fields
    [:author_ids, :title, :institution_id, :serie, :volume, :subtype, :place_ids, :year, :month, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'file'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  attr_json :institution_id, :integer
  attr_json :year, :string

  attr_json :subtype, :string
  belongs_to :serie, class_name: 'Biblio::Serie', foreign_key: :parent_id, optional: true
  attr_json :number, :string
  attr_json :place_ids, :integer, array: true
  attr_json :month, :string
  attr_json :note, :string
  attr_json :key, :string
  
  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

  validates :authors, :title, :institution_id, :year, presence: true

  def institution
    institution_id.present? ? Zensus::Appellation.find(institution_id) : nil
  end

  def places
    place_ids.any? ? Locate::Toponym.find(place_ids) : []
  end

  accepts_nested_attributes_for :serie, reject_if: :all_blank, allow_destroy: false

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name),
      title: title,
      institution: institution.try(:name),
      year: year,
      subtype: subtype,
      series: [serie.try(:title), serie.try(:abbr), serie.try(:print_issn)].compact,
      number: number,
      address: places.map(&:given),
      note: note,
      url: url,
      doi: doi,
      abstract: abstract,
      tags: tag_list
    }
  end

  def to_bib
    BibTeX::Entry.new({
      :bibtex_type => type.demodulize.downcase.to_sym,
      :bibtex_key => bibtex_citation,
      :author => creators_name_list.map{ |a| a.name(reverse: true) }.join(' and '),
      :title => title,
      :institution => institution.try(:name),
      :year => year,
      :type => subtype,
      :series => serie.try(:title),
      :number => number,
      :address => places.map(&:given).join('; '),
      :month => month,
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
      obj.subtype = bibtex.try(:type)
      obj.serie = Biblio::Serie.jsonb_contains(title: bibtex.series).first.try(:id) || Biblio::Serie.create(title: bibtex.series, print_issn: bibtex.try(:issn)).id if bibtex.try(:series)
      obj.number = bibtex.try(:number)
      obj.place_ids = bibtex.address.split('; ').map{|a| Locate::Toponym.find_by_given(a).try(:id) || Locate::Toponym.create(given: a).id if a } if bibtex.try(:address)
      obj.institution_id = Zensus::Appellation.find_by_name(bibtex.institution).first.try(:id) || Zensus::Appellation.create(name: bibtex.institution).id if bibtex.try(:institution)
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