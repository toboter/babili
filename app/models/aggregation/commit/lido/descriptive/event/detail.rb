# Title: Event
# General: Identifying, descriptive and indexing information for the events in which the object participated or 
# was present at, e.g. creation, excavation, collection, and use.
# Notes: All information related to the creation of an object: creator, cutlural context, creation date, 
# creation place, the material and techniques used are recorded here, qualified by the event type “creation”.

class Aggregation::Commit::Lido::Descriptive::Event::Detail
  include JsonAttribute::Model

  json_attribute :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :types, Aggregation::Commit::Lido::Descriptive::Event::Type.to_type # 1
  json_attribute :in_roles, Aggregation::Commit::Lido::Descriptive::Event::InRole.to_type, array: true # 0..n
  json_attribute :names, Aggregation::Commit::Lido::Concerns::Appellation.to_type, array: true # 0..n
  json_attribute :actors, Aggregation::Commit::Lido::Concerns::Actor::Base.to_type, array: true # 0..n
  json_attribute :cultures, Aggregation::Commit::Lido::Descriptive::Event::Culture.to_type, array: true  # 0..n
  json_attribute :date, Aggregation::Commit::Lido::Concerns::Date.to_type # 1
  json_attribute :periods, Aggregation::Commit::Lido::Descriptive::Event::Period.to_type, array: true  # 0..n
  json_attribute :places, Aggregation::Commit::Lido::Concerns::Place.to_type, array: true  # 0..n
  json_attribute :methods, Aggregation::Commit::Lido::Descriptive::Event::Method.to_type, array: true # 0..n
  json_attribute :materials_techniques, Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Base.to_type, array: true # 0..n
  json_attribute :things, Aggregation::Commit::Lido::Concerns::Thing.to_type, array: true # 0..n
  json_attribute :related_events, Aggregation::Commit::Lido::Descriptive::Event::RelatedEvent::Base.to_type, array: true # 0..n
  json_attribute :descriptions, Aggregation::Commit::Lido::Descriptive::Event::Description.to_type, array: true  # 0..n
end