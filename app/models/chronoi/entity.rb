require 'chronic'

module Chronoi
  class Entity < ApplicationRecord
    # t.string    :type
    # self.inheritance_column = :_type_disabled
    # t.string    :title
    # t.text      :note
    # t.string    :begins_at_string
    # t.string    :ends_at_string
    # t.boolean   :circa
    # t.datetime  :begins_at_date
    # t.datetime  :ends_at_date

    has_many    :chronoi_entity_vocab_types, class_name: 'Property::HasType', foreign_key: :entity_id
    has_many    :equals_in_time_to_chronoi_entities, class_name: 'Property::IsEqualInTimeTo', foreign_key: :entity_id
    has_many    :finishes_chronoi_entities, class_name: 'Property::Finishes', foreign_key: :entity_id
    has_many    :starts_chronoi_entities, class_name: 'Property::Starts', foreign_key: :entity_id
    has_many    :occurs_during_chronoi_entities, class_name: 'Property::OccursDuring', foreign_key: :entity_id
    has_many    :overlaps_in_time_with_chronoi_entities, class_name: 'Property::OverlapsInTimeWith', foreign_key: :entity_id
    has_many    :meets_in_time_with_chronoi_entities, class_name: 'Property::MeetsInTimeWith', foreign_key: :entity_id
    has_many    :occurs_before_chronoi_entities, class_name: 'Property::OccursBefore', foreign_key: :entity_id
      
    has_many    :properties, dependent: :destroy
    belongs_to  :creator, class_name: "Person", optional: true

    validates :type, presence: true

    # searchkick inheritance: true

    before_validation :parse_date
    #after_commit :reindex_agents

    def default_date
      "#{'~ ' if circa?}#{begins_at}#{' - '+ends_at if ends_at.present?}"
    end

    def description
      "#{title} #{'('+properties.map{|a| a.description }.join(', ')+')' if properties.any?}"
    end

    def parse_date
      self.begins_at_date = Chronic.parse(begins_at_string, guess: !circa) if begins_at_string
      self.ends_at_date = Chronic.parse(ends_at_string, guess: !circa) if ends_at_string
    end

    def reindex_agents
      agents.reindex
    end

    def begins_at
      begins_at_string
    end

    def ends_at(full=false)
      full ? begins_at : ends_at_string
    end

    # Searching for ranges
    # https://github.com/ankane/searchkick/issues/973
    def search_data
      {
        description: description,
        begins_at: begins_at_date,
        ends_at: ends_at_date,
        related_events: related_events.map(&:description).join(' '),
        place: place.try(:names)
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

    # E2 Temporal Entity
    # Subclass of: Ε1 CRM Entity
    # Superclass of: Ε3 Condition State
    # E4 Period
    # Scope note: This class comprises all phenomena, such as the instances of E4 Periods, E5 Events and states,
    # which happen over a limited extent in time.
    # In some contexts, these are also called perdurants. This class is disjoint from E77 Persistent
    # Item. This is an abstract class and has no direct instances. E2 Temporal Entity is specialized
    # into E4 Period, which applies to a particular geographic area (defined with a greater or lesser
    # degree of precision), and E3 Condition State, which applies to instances of E18 Physical
    # Thing.
    # Examples:
    #  Bronze Age (E4)
    #  the earthquake in Lisbon 1755 (E5)
    #  the Peterhof Palace near Saint Petersburg being in ruins from 1944 – 1946 (E3)
    # Properties:
    # P4 has time-span (is time-span of): E52 Time-Span
    # P114 is equal in time to: E2 Temporal Entity
    # P115 finishes (is finished by): E2 Temporal Entity
    # P116 starts (is started by): E2 Temporal Entity
    # P117 occurs during (includes): E2 Temporal Entity
    # P118 overlaps in time with (is overlapped in time by): E2 Temporal Entity
    # P119 meets in time with (is met in time by): E2 Temporal Entity
    # P120 occurs before (occurs after): E2 Temporal Entity
    # E1 Properties:
    # P1 is identified by (identifies): E41 Appellation
    # P2 has type (is type of): E55 Type
    # P3 has note: E62 String
    # (P3.1 has type: E55 Type)
    # P48 has preferred identifier (is preferred identifier of): E42 Identifier
    # P137 exemplifies (is exemplified by): E55 Type
    # (P137.1 in the taxonomic role: E55 Type)
  end
end