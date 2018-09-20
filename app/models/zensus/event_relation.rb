module Zensus
  class EventRelation < ApplicationRecord
    # t.integer   :event_id
    # t.integer   :property_id
    # t.integer   :related_event_id

    after_commit :reindex_event, on: [:create, :update]

    belongs_to :event
    belongs_to :related_event, class_name: 'Event'

    def self.properties
      # event, property, other event
      [
        {id: 1, property: ['falls within', 'contains']},
        {id: 2, property: ['is equal in time to', 'is equal in time to']},
        {id: 3, property: ['finishes', 'is finished by']},
        {id: 4, property: ['starts' 'is started by']},
        {id: 5, property: ['occurs during', 'includes']},
        {id: 6, property: ['overlaps in time with', 'is overlapped in time by']},
        {id: 7, property: ['meets in time with', 'is met in time by']},
        {id: 8, property: ['occurs before', 'occurs after']},
        {id: 9, property: ['starts before or at the end of', 'ends with or after the start of']},
        {id: 10, property: ['starts before', 'starts after the start of']},
        {id: 11, property: ['starts before or with the start of', 'starts with or after the start of']},
        {id: 12, property: ['starts before the start of', 'starts after the start of']},
        {id: 13, property: ['ends before or at the start of', 'starts with or after the end of']},
        {id: 14, property: ['ends before the start of', 'starts after the end of']},
        {id: 15, property: ['ends before or with the end of', 'ends with or after the end of']},
        {id: 16, property: ['ends before the end of', 'ends after the end of']}
      ]
    end

    def title
      Zensus::EventRelation.properties.select {|p| p[:id] == property_id }.first[:property].first
    end

    def inverse_title
      Zensus::EventRelation.properties.select {|p| p[:id] == property_id }.first[:property].last
    end

    def reindex_event
      event.reindex
      related_event.reindex
    end
  end
end