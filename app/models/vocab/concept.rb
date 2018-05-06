# t.integer    :id
# t.string     :uuid
# t.integer    :scheme_id
# t.string     :type
# t.integer    :creator_id
# t.string     :status
# t.string     :slug

class Vocab::Concept < ApplicationRecord
  include Rails.application.routes.url_helpers
  self.inheritance_column = :_type_disabled
  searchkick
  acts_as_dag(link_table: 'vocab_links', descendant_table: 'vocab_descendants')

  has_many :broader_concepts, 
    through: :parent_links, 
    source: :parent  # parents
  has_many :narrower_concepts, 
    through: :child_links, 
    source: :child   # children
  # Can also be a literal to anywhere
  has_many :matches, class_name: 'AssociativeRelation', foreign_key: :concept_id, dependent: :destroy
  has_many :object_matches, as: :associatable, class_name: 'AssociativeRelation'

  before_validation :add_uuid, on: :create
  extend FriendlyId
  friendly_id :uuid, use: :slugged
  # broaderTransitive -> https://www.w3.org/TR/2009/NOTE-skos-primer-20090818/#sectransitivebroader
  # paper_trail into changeNote
  after_commit :reindex_matches

  belongs_to :scheme, touch: true
  has_one :namespace, through: :scheme
  belongs_to :creator, class_name: 'Person'
  has_many :labels, class_name: 'Vocab::Label', dependent: :destroy, inverse_of: :concept
  has_many :notes, dependent: :destroy, inverse_of: :concept
  has_many :definitions, -> { where type: 'Definition' }, class_name: 'Note'

  accepts_nested_attributes_for :labels, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :matches, reject_if: :all_blank, allow_destroy: true

  validates :status, :type, :creator, :scheme, :uuid, :labels, presence: true

  # surpress double entries in search, only show the original
  scope :search_import, -> { matches.where.not(associatable_type: "Vocab::Concept", property: "exact") }
  def should_index?
    !matches.where(associatable_type: "Vocab::Concept", property: "exact").exists?
  end

  def search_data
    {
      broader: broader_concepts.map(&:name).join(' '),
      narrower: narrower_concepts.map(&:name).join(' '),
      scheme: scheme.title,
      labels: labels.map(&:body).join(' '),
      notes: notes.map(&:body).join(' '),
      matches: matches.map{|m| [m.property, m.associatable.name] }.join(' ')
    }
  end

  def reindex_matches
    assocs = matches.where(associatable_type: "Vocab::Concept").map(&:associatable)
    assocs.each(&:reindex)
  end

  def preferred_label(lang=nil)
    labels.where(type: 'Preferred', language: lang, is_abbrevation: false).first || labels.where(type: 'Preferred', is_abbrevation: false).first
  end

  def name(lang=nil)
    type == 'Collection' ? "<#{preferred_label(lang).try(:body)}>" : preferred_label(lang).try(:body)
  end

  def default_name
    name
  end

  def uri
    url_for([scheme.namespace, :vocab, scheme, self])
  end

  def api_uri
    url_for([:api, scheme.namespace, :vocab, scheme, self])
  end

  # Hierarchy, Concept, GuideTerm? -> Collections
  def self.types
    %w(Concept Collection)
  end

  def self.statuses
    %w(Unstable Testing Stable)
  end

  def indent
    ancestor_links.first ? (ancestor_links.first.distance.to_i+1)*17 : 20
  end

  def contributors
    [creator].concat(labels.map(&:creator)).concat(notes.map(&:creator)).flatten.uniq
  end

  def add_uuid
    self.uuid = loop do
      random_token = SecureRandom.hex(4)+'-'+scheme.id.to_s.rjust(4, '0')+'-'+SecureRandom.hex(2)+'-'+SecureRandom.hex(2)
      break random_token unless self.class.exists?(uuid: random_token)
    end 
  end

  def broader_concepts=(ids)
    ids = ids.reject { |c| c.empty? }.split(",").flatten
    parents = Vocab::Concept.find(ids)
    (self.parents - parents).each do |parent_to_remove|
      remove_parent(parent_to_remove)
    end
    self.parents = parents
    unless self.new_record?
      parents.empty? ? self.make_root : ActsAsDAG::HelperMethods.unlink(nil, self)
    end
  end

  def narrower_concepts=(ids)
    ids = ids.reject { |c| c.empty? }.split(",").flatten
    children = Vocab::Concept.find(ids)
    (self.children - children).each do |child_to_remove|
      remove_child(child_to_remove)
      child_to_remove.parents.empty? ? child_to_remove.make_root : ActsAsDAG::HelperMethods.unlink(nil, child_to_remove)
    end
    self.children = children
    children.each do |child|
      ActsAsDAG::HelperMethods.unlink(nil, child)
    end
  end

  def self.sorted_by(sort_option)
    direction = ((sort_option =~ /desc$/) ? 'desc' : 'asc').to_sym
    case sort_option.to_s
    when /^updated_at_/
      { updated_at: direction }
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  end

  def self.options_for_sorted_by
    [
      ['Updated asc', 'updated_at_asc'],
      ['Updated desc', 'updated_at_desc']
    ]
  end
end