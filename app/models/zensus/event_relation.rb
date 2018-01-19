# t.integer   :event_id
# t.integer   :property_id
# t.integer   :related_event_id

class Zensus::EventRelation < ApplicationRecord
  belongs_to :event
  belongs_to :related_event, class_name: 'Zensus::Event'

  def self.properties
    # event, property, other event
    # [
    #   {'falls within', 'contains'},
    #   {'is equal in time to', 'is equal in time to'},
    #   {'finishes', 'is finished by'},
    #   {'starts' 'is started by'},
    #   {'occurs during', 'includes'},
    #   {'overlaps in time with', 'is overlapped in time by'},
    #   {'meets in time with', 'is met in time by'},
    #   {'occurs before', 'occurs after'},
    #   {'starts before or at the end of', 'ends with or after the start of'},
    #   {'starts before', 'starts after the start of'},
    #   {'starts before or with the start of', 'starts with or after the start of'},
    #   {'starts before the start of', 'starts after the start of'},
    #   {'ends before or at the start of', 'starts with or after the end of'},
    #   {'ends before the start of', 'starts after the end of'},
    #   {'ends before or with the end of', 'ends with or after the end of'},
    #   {'ends before the end of', 'ends after the end of'}
    # ]
  end

end