# Title: Related Event
# General: References an event which is linked in some way to this event, e.g. a field trip within which 
# this object was collected.

class Aggregation::Commit::Lido::Descriptive::Event::RelatedEvent::Base
  include AttrJson::Model

  attr_json :event, Aggregation::Commit::Lido::Descriptive::Event::Base.to_type # 0..1
  attr_json :relationship_type, Aggregation::Commit::Lido::Descriptive::Event::RelatedEvent::RelationshipType.to_type # 0..1
end