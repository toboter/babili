class Biblio::Entry < ApplicationRecord
  #require 'csl/styles'
  extend FriendlyId
  searchkick inheritance: true
  include ActionView::Helpers::TextHelper
  has_closure_tree dependent: :destroy
  acts_as_taggable
  before_validation :set_citation_raw
  #acts_as_sequenced scope: :citation_raw
  before_create :set_citation_sequence
  friendly_id :id, use: :slugged

  has_many :creatorships, dependent: :destroy, class_name: 'Biblio::Creatorship', foreign_key: :entry_id
  has_many :creators, -> { order 'biblio_creatorships.id asc' }, through: :creatorships, source: :agent_appellation
  belongs_to :creator, class_name: 'Person'
  has_many :referencations, class_name: 'Biblio::Referencation', dependent: :destroy
  has_many :repositories, through: :referencations

  def self.types
    [
      'Biblio::Article',
      'Biblio::Book',
      'Biblio::Booklet',
      'Biblio::Collection',
      'Biblio::InBook',
      'Biblio::InCollection',
      'Biblio::InProceeding',
      'Biblio::Journal',
      'Biblio::Manual',
      'Biblio::Masterthesis',
      'Biblio::Misc',
      'Biblio::Phdthesis',
      'Biblio::Proceeding',
      'Biblio::Serie',
      'Biblio::Techreport',
      'Biblio::Unpublished'
    ]
  end

  scope :with_creators, lambda{ |names|
    c_ids = creator_ids(names)
    return self.none if c_ids.include?(nil)
    # get a reference to the join table
    creator_assignments = Biblio::Creatorship.arel_table
    # get a reference to the filtered table
    entries = Biblio::Entry.arel_table
    # let AREL generate a complex SQL query
    c_ids.map(&:to_i).inject(self) { |rel, c_id|
      rel.where(
        Biblio::Creatorship \
          .where(creator_assignments[:entry_id].eq(entries[:id]) \
          .and(creator_assignments[:agent_appellation_id].eq(c_id))) \
          .exists
      )
    }
  }

  def self.creator_ids(names)
    appellation_ids =[]
    names.each do |name|
      appellation_ids << Zensus::Appellation.find_by_name(name).first.try(:id)
    end
    appellation_ids
  end

  def should_generate_new_friendly_id?
    true || super
  end

  def authors_list(limit=nil, reverse=true, join_by='; ')
    authors.limit(limit).map{ |a| a.name(reverse: reverse) }.join(join_by) + ' '
  end

  def editors_list(limit=nil, reverse=true)
    editors.limit(limit).map{ |a| a.name(reverse: true) }.join(', ') + " (#{'Ed'.pluralize(editors.count)}.) "
  end


  def citation_authors_list
    authors.take(3).map{ |a| a.name(reverse: true).split(', ').first }.join(', ') + ' '
  end

  def citation_editors_list
    editors.take(3).map{ |a| a.name(reverse: true).split(', ').first }.join(', ') + " (#{'Ed'.pluralize(editors.count)}.) "
  end


  # set unique citation
  def set_citation_raw
    if self.respond_to?(:authors) && !self.type.in?(['Biblio::Serie', 'Biblio::Journal'])
      if authors.any?
        self.citation_raw = (authors.count > 3 ? citation_authors_list.concat('et al. ') : citation_authors_list).concat(self.respond_to?(:year) ? (year.present? ? year : '') : '')
      else
        self.citation_raw = key
      end
    elsif self.respond_to?(:editors) && !self.type.in?(['Biblio::Serie', 'Biblio::Journal'])
      if editors.any?
        self.citation_raw = (editors.count > 3 ? citation_editors_list.concat('et al. ') : citation_editors_list).concat(self.respond_to?(:year) ? (year.present? ? year : '') : '')
      else
        self.citation_raw = key
      end
    elsif self.type == 'Biblio::Serie'
      self.citation_raw = key.present? ? key : title
    elsif self.type == 'Biblio::Journal'
      self.citation_raw = key.present? ? key : (name + "#{' [' + abbr + ']' if abbr.present?}")
    end
  end

  def set_citation_sequence
    last_record = Biblio::Entry.where(citation_raw: self.citation_raw).order(sequential_id: :asc).last
    new_seq_id = last_record.present? ? (last_record == self ? last_record.sequential_id : last_record.sequential_id+1) : 1
    self.sequential_id = new_seq_id if sequential_id.blank?
  end

  def bibtex_citation
    citation.gsub(/[,()]/ ,"")
  end

  def citation
    "#{citation_raw}#{numeric_to_alph(sequential_id) if sequential_id > 1 && !self.type.in?(['Biblio::Serie', 'Biblio::Journal'])}"
  end

  def bibliographic(style='apa', locale='en-US')
    csl_style = CSL::Style.load(style)
    csl_locale = CSL::Locale.load(locale)

    citation_item = CiteProc::CitationItem.new(id: self.bibtex_citation) do |c|
      c.data = CiteProc::Item.new(self.to_bib.to_citeproc)
    end

    cpr = CiteProc::Ruby::Renderer.new(:format => 'html', :style => csl_style, :locale => csl_locale)
    cpr.render(citation_item, csl_style.bibliography).html_safe

  end

  Alpha26 = ("a".."z").to_a
  def numeric_to_alph(value)
    return "" if value.nil? || value < 1
    s, q = "", value
    loop do
      q, r = (q - 1).divmod(26)
      s.prepend(Alpha26[r]) 
      break if q.zero?
    end
    s
  end
end