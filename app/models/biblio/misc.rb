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
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  self.default_json_container_attribute = 'data'

  CREATOR_TYPES = %w(Author)
  DESCRIPTION = 'Use this type when nothing else seems appropriate.'
  def icon
    'file'
  end

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :authors, through: :creatorships, source: :agent_appellation
  json_attribute :title, :string
  json_attribute :howpublished, :string
  json_attribute :month, :string
  json_attribute :year, :string
  json_attribute :note, :string
  json_attribute :key, :string
  
  json_attribute :url, :string
  json_attribute :doi, :string
  json_attribute :abstract, :string

  def search_data
    {
      citation: citation,
      entry_type: type.demodulize,
      author: authors.map(&:name).join(' '),
      title: title,
      year: year,
      howpublished: howpublished,
      tag: tag_list.join(' '),
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