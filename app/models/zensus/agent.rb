# t.integer   :id
# t.string    :slug
# t.string    :type
# t.text      :address

class Zensus::Agent < ApplicationRecord
  extend FriendlyId
  friendly_id :default_name, use: :slugged

  has_many :appellations, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :activities, as: :actable, dependent: :destroy
  has_many :events, through: :activities
  has_many :places, through: :events
  has_many :notes, as: :issueable

  accepts_nested_attributes_for :appellations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true

  def default_name
    appellations.first.name
  end

  def should_generate_new_friendly_id?
    appellations.any? { |a| a.changed? } || super
  end

  def self.types
    %w[Person Group]
  end

end



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