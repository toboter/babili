# t.integer   :id
# t.string    :slug
# t.string    :type
# t.text      :address
# t.integer   :default_appellation_id

class Zensus::Agent < ApplicationRecord
  searchkick inheritance: true
  extend FriendlyId
  friendly_id :default_name, use: :slugged

  has_many :appellations, dependent: :nullify
  has_many :links, dependent: :destroy
  has_many :activities, as: :actable, dependent: :destroy
  has_many :events, through: :activities
  has_many :places, through: :events
  has_many :notes, as: :issueable

  accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :appellations, presence: :true

  def default_name
    appellations.first.try(:name)
  end

  def should_generate_new_friendly_id?
    appellations.any? { |a| a.changed? } || super
  end

  def self.types
    %w[Person Group]
  end

  def search_data
    {
      name: default_name,
      appellations: appellations.map{ |a| a.name(prefix: true, suffix: true, preferred: false) }.join(' '),
      activities: activities.map{ |a| a.title }.join(' ')
    }
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

# Suche
# API
# datepicker
# media-links - polymorphic, create in / upload to commons.b-o, local link


# Actor (< PersistentItem)
# E21 Person
# E74 Group
# P74 has current or former residence (is current or former residence of): E53 Place (P87 is identified by (identifies): E44 Place Appellation)
# P75 possesses (is possessed by): E30 Right
# P76 has contact point (provides access to): E51 Contact Point (E45 Address)
# P131 is identified by (identifies): E41 Appellation
#  
# Type < Concept
# ( interface to domain specific ontologies and thesauri. )
# E56 Language
# E57 Material
# E58 Measurement Unit
# P127 has broader term (has narrower term): E55 Type
# P150 defines typical parts of(define typical wholes for): E55 Type
# 
# Language < Type