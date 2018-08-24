# misc entry
# Use this type when nothing else seems appropriate.
# 
# Format:
# 
#      @MISC{citation_key,
#            required_fields [, optional_fields] }
# Required fields: none
# 
# Optional fields: author, title, howpublished, month, year, note, key

class Biblio::Misc < Biblio::Entry
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :data)

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'Use this type when nothing else seems appropriate.'
  def fields
    [:author_ids, :title, :howpublished, :year, :month, :note, :key, :url, :doi, :abstract, :tag_list]
  end
  def icon
    'file'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  attr_json :title, :string
  attr_json :howpublished, :string
  attr_json :month, :string
  attr_json :year, :string
  attr_json :note, :string
  attr_json :key, :string
  
  attr_json :url, :string
  attr_json :doi, :string
  attr_json :abstract, :string

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name),
      title: title,
      year: year,
      howpublished: howpublished,
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
      :year => year,
      :month => month,
      :howpublished => howpublished,
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
      obj.howpublished = bibtex.try(:howpublished)
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