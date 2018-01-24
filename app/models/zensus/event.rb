# t.string    :type
# t.string    :beginn
# t.string    :ended
# t.boolean   :circa
# t.integer   :place_id
# t.integer   :period_id
require 'chronic'

class Zensus::Event < ApplicationRecord
  self.inheritance_column = :_type_disabled
  searchkick
  
  has_many    :notes, as: :issueable
  has_many    :event_relations, dependent: :destroy
  has_many    :related_events, through: :event_relations
  has_many    :inverse_event_relations, dependent: :destroy, class_name: 'Zensus::EventRelation', foreign_key: :related_event_id
  has_many    :inverse_related_events, through: :inverse_event_relations, source: :event
  has_many    :activities, dependent: :destroy
  has_many    :agents, through: :activities, source_type: 'Zensus::Agent', source: :actable
  has_many    :notes, as: :issueable
  belongs_to  :place, class_name: 'Vocab::Concept'
  belongs_to  :period, class_name: 'Vocab::Concept'

  accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :event_relations, reject_if: :all_blank, allow_destroy: true

  validates :type, :begins_at_string, presence: true

  before_validation :parse_date

  def self.types
    ['Activity', 'Acquisition', 'Move', 'Transfer of Custody', 'Beginning of Existence', 'Formation', 'Birth', 'Transformation', 'Joining', 'End of Existence', 'Dissolution', 'Death', 'Leaving']
  end

  def default_date
    "#{'~ ' if circa?}#{begins_at}#{' - '+ends_at if ends_at.present?}"
  end

  def title
    "#{type} #{'on ' + default_date}"
  end

  def description
    #raise actor.activities.where(event_id: id).inspect #.where(actable_id: agent.id, actable_type: agent.class.base_class)
    "#{type} #{'on ' + default_date} #{'('+activities.map{|a| a.description }.join(', ')+')' if activities.any?}"
  end

  def parse_date
    self.begins_at_date = Chronic.parse(begins_at_string, guess: !circa) if begins_at_string
    self.ends_at_date = Chronic.parse(ends_at_string, guess: !circa) if ends_at_string
  end

  def begins_at
    begins_at_date.try(:to_date).try(:to_s) || begins_at_string || nil
  end

  def ends_at
    ends_at_date.try(:to_date).try(:to_s) || ends_at_string || nil
  end

  def search_data
    {
      description: description,
      date: default_date,
      related_events: related_events.map(&:description).join(' ')
    }
  end

end

# Entity
# P1 is identified by (identifies): E41 Appellation
# P2 has type (is type of): E55 Type
#e P3 has note: E62 String
# (P3.1 has type: E55 Type)
# P48 has preferred identifier (is preferred identifier of): E42 Identifier
# P137 exemplifies (is exemplified by): E55 Type
# (P137.1 in the taxonomic role: E55 Type)

# Temp Entity < Entity
#e P4 has time-span (is time-span of): E52 Time-Span
#  E52 P78 is identified by (identifies): E49 Time Appellation
#  E52 P79 beginning is qualified by: E62 String
#  E52 P80 end is qualified by: E62 String
#  E52 P81 ongoing throughout: E61 Time Primitive
#  E52 P82 at some time within: E61 Time Primitive
#  E52 P83 had at least duration (was minimum duration of): E54 Dimension
#  E52 P84 had at most duration (was maximum duration of): E54 Dimension
#  E52 P86 falls within (contains): E52 Time-Span
# P114 is equal in time to: E2 Temporal Entity
# P115 finishes (is finished by): E2 Temporal Entity
# P116 starts (is started by): E2 Temporal Entity
# P117 occurs during (includes): E2 Temporal Entity
# P118 overlaps in time with (is overlapped in time by): E2 Temporal Entity
# P119 meets in time with (is met in time by): E2 Temporal Entity
# P120 occurs before (occurs after): E2 Temporal Entity
# P173 starts before or at the end of (ends with or after the start of): E2 Temporal Entity
# P174 starts before (starts after the start of): E2 Temporal Entity
# P175 starts before or with the start of (starts with or after the start of) : E2 Temporal Entity
# P176 starts before the start of (starts after the start of): E2 Temporal Entity
# P182 ends before or at the start of (starts with or after the end of) : E2 Temporal Entity
# P183 ends before the start of (starts after the end of) : E2 Temporal Entity
# P184 ends before or with the end of (ends with or after the end of) : E2 Temporal Entity
# P185 ends before the end of (ends after the end of): E2 Temporal Entityy

# Spacetime Volume < Entity
#i P10 falls within (contains): E92 Spacetime Volume
#i P132 spatiotemporally overlaps with: E92 Spacetime Volume
#i P133 spatiotemporally separated from: E92 Spacetime Volume
# P160 has temporal projection: E52 Time-Span
# P161 has spatial projection: E53 Place

# Period < Temporal Entity
# Period < Spacetime Volume
#e P7 took place at (witnessed): E53 Place
#e P8 took place on or within (witnessed): E18 Physical Thing
#i P9 consists of (forms part of): E4 Period

# Event < Period
#e P11 had participant (participated in): E39 Actor
#e P12 occurred in the presence of (was present at): E77 Persistent Item (Actor, Thing)

# -> Activity
# Beginning of Existence < Event
# P92 brought into existence (was brought into existence by): E77 Persistent Item

# Formation < Beginning of Existence
# P95 has formed (was formed by): E74 Group
# P151 was formed from: E74 Group

# Birth < Beginning of Existence
# P96 by mother (gave birth): E21 Person
# P97 from father (was father for): E21 Person
# P98 brought into life (was born): E21 Person

# Transformation < Beginning of Existence
# P123 resulted in (resulted from): E77 Persistent Item
# P124 transformed (was transformed by): E77 Persistent Item

# End of Existence < Event
# P93 took out of existence (was taken out of existence by): E77 Persistent Item

# Dissolution < End of Existence
# P99 dissolved (was dissolved by): E74 Group

# Death < End of Existence
# P100 was death of (died in): E21 Person

# Transformation < End of Existence
# P123 resulted in (resulted from): E77 Persistent Item
# P124 transformed (was transformed by): E77 Persistent Item)


# Activity < Event
# E8 Acquisition
# E9 Move
# E10 Transfer of Custody
# E11 Modification
# E13 Attribute Assignment
# E65 Creation 
#   P94 has created (was created by): E28 Conceptual Object
# E66 Formation 
#   P95 has formed (was formed by): E74 Group
#   P151 was formed from: E74 Group
#! E85 Joining 
#   P143 joined (was joined by): E39 Actor
#   P144 joined with (gained member by) E74 Group
#   (P144.1 kind of member: E55 Type)
#! E86 Leaving 
#   P145 separated (left by) E39 Actor
#   P146 separated from (lost member by) E74 Group
# E87 Curation Activity

# P14 carried out by (performed): E39 Actor
# (P14.1 in the role of: E55 Type)
# P15 was influenced by (influenced): E1 CRM Entity
# P16 used specific object (was used for): E70 Thing
# (P16.1 mode of use: E55 Type)
# P17 was motivated by (motivated): E1 CRM Entity
# P19 was intended use of (was made for): E71 Man-Made Thing
# (P19.1 mode of use: E55 Type)
# P20 had specific purpose (was purpose of): E5 Event
# P21 had general purpose (was purpose of): E55 Type
# P32 used general technique (was technique of): E55 Type
# P33 used specific technique (was used by): E29 Design or Procedure
# P125 used object of type (was type of object used in): E55 Type
# P134 continued (was continued by): E7 Activity