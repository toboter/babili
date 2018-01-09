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
  acts_as_dag(link_table: 'vocab_links', descendant_table: 'vocab_descendants')
  has_many :broader_concepts, 
    through: :parent_links, 
    source: :parent  # parents
  has_many :narrower_concepts, 
    through: :child_links, 
    source: :child   # children
  # Can also be a literal to anywhere
  has_many :matches, class_name: 'AssociativeRelation', foreign_key: :concept_id, dependent: :destroy

  before_validation :add_uuid, on: :create
  extend FriendlyId
  friendly_id :uuid, use: :slugged
  # broaderTransitive -> https://www.w3.org/TR/2009/NOTE-skos-primer-20090818/#sectransitivebroader
  # paper_trail into changeNote

  belongs_to :scheme
  belongs_to :creator, class_name: 'User'
  has_many :labels, dependent: :destroy, inverse_of: :concept
  has_many :notes, dependent: :destroy, inverse_of: :concept
  has_many :definitions, -> { where type: 'Definition' }, class_name: 'Note'

  accepts_nested_attributes_for :labels, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :notes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :matches, reject_if: :all_blank, allow_destroy: true

  def preferred_label(lang=nil)
    labels.where(type: 'Preferred', language: lang, is_abbrevation: false).first || labels.where(type: 'Preferred', is_abbrevation: false).first
  end

  def name(lang=nil)
    type == 'Collection' ? "<#{preferred_label(lang).try(:body)}>" : preferred_label(lang).try(:body)
  end

  def uri
    url_for([:vocab, scheme, self])
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
    [creator] #.concat(labels.map{|l| l.creator}).concat(notes.map{|n| n.try(:creator)}).compact.flatten.uniq
  end

  def add_uuid
    self.uuid = loop do
      random_token = SecureRandom.hex(4)+'-'+scheme.id.to_s.rjust(4, '0')+'-'+SecureRandom.hex(2)+'-'+SecureRandom.hex(2)+'-'+SecureRandom.hex(6)
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
    end
    self.children = children
    # unless self.new_record?
    #   children.empty? ? self.make_root : ActsAsDAG::HelperMethods.unlink(nil, self)
    # end
  end
end