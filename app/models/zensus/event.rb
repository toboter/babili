require 'chronic'

module Zensus
  class Event < ApplicationRecord
    # t.string    :type
    #   ->out of vocab::concept.where(label: ['Person', 'Group']).narrower_concepts
    # t.string    :beginn
    # t.string    :ended
    # t.boolean   :circa
    # t.integer   :place_id
    # t.integer   :period_id

    self.inheritance_column = :_type_disabled
    searchkick
    
    has_many    :notes, as: :issueable
    has_many    :event_relations, dependent: :destroy
    has_many    :related_events, through: :event_relations
    has_many    :inverse_event_relations, dependent: :destroy, class_name: 'EventRelation', foreign_key: :related_event_id
    has_many    :inverse_related_events, through: :inverse_event_relations, source: :event
    has_many    :activities, dependent: :destroy
    has_many    :agents, through: :activities, source_type: 'Zensus::Agent', source: :actable
    has_many    :notes, as: :issueable
    belongs_to  :place, class_name: 'Locate::Place'
    belongs_to  :period, class_name: 'Vocab::Concept'
    belongs_to  :creator, class_name: "Person"

    accepts_nested_attributes_for :activities, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :event_relations, reject_if: :all_blank, allow_destroy: true

    validates :type, presence: true

    before_validation :parse_date
    after_commit :reindex_agents

    def self.types
      ['Activity', 'BeginningOfExistence', 'Formation', 'Birth', 'Transformation', 'Joining', 'EndOfExistence', 'Dissolution', 'Death', 'Leaving', 'GenderAssignment', 'Marriage', 'Survey', 'Excavation']
    end

    def default_date
      "#{'~ ' if circa?}#{begins_at}#{' - '+ends_at if ends_at.present?}"
    end

    def title
      "#{type} #{'on ' + default_date if begins_at.present?}"
    end

    def description
      #raise actor.activities.where(event_id: id).inspect #.where(actable_id: agent.id, actable_type: agent.class.base_class)
      "#{title} #{'('+activities.map{|a| a.description }.join(', ')+')' if activities.any?}"
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

  end
end