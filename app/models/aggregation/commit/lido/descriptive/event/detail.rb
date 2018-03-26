# Title: Event
# General: Identifying, descriptive and indexing information for the events in which the object participated or 
# was present at, e.g. creation, excavation, collection, and use.
# Notes: All information related to the creation of an object: creator, cutlural context, creation date, 
# creation place, the material and techniques used are recorded here, qualified by the event type “creation”.

class Aggregation::Commit::Lido::Descriptive::Event::Detail
  include JsonAttribute::Model

  json_attribute :identifiers, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :type, Aggregation::Commit::Lido::Descriptive::Event::Type.to_type # 1
  json_attribute :in_role, Aggregation::Commit::Lido::Descriptive::Event::InRole.to_type, array: true # 0..n
  json_attribute :name, Aggregation::Commit::Lido::Concerns::Appellation::Base.to_type, array: true # 0..n
  json_attribute :actor, :string # 0..n
  json_attribute :culture, Aggregation::Commit::Lido::Descriptive::Event::Culture.to_type, array: true  # 0..n
  json_attribute :date, Aggregation::Commit::Lido::Descriptive::Event::Date::Base.to_type # 1
  json_attribute :period, Aggregation::Commit::Lido::Descriptive::Event::Period.to_type, array: true  # 0..n
  json_attribute :place, Aggregation::Commit::Lido::Descriptive::Event::Place.to_type, array: true  # 0..n
  json_attribute :method, Aggregation::Commit::Lido::Descriptive::Event::Method.to_type, array: true # 0..n
  json_attribute :materialsTech, :string # 0..n
  json_attribute :thingPresent, :string # 0..n
  json_attribute :related_events, :string # 0..n
  json_attribute :descriptions, :string # 0..n
end