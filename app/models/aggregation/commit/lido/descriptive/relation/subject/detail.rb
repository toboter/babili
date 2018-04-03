# Title: Subject
# General: Contains sub-elements for a structured subject description. These identify, describe, and/or 
# interpret what is depicted in and by an object / work or what it is about.

class Aggregation::Commit::Lido::Descriptive::Relation::Subject::Detail
  include JsonAttribute::Model

  json_attribute :extent, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :actors, Aggregation::Commit::Lido::Concerns::Actor.to_type, array: true # 0..n
  json_attribute :dates, Aggregation::Commit::Lido::Concerns::Date.to_type, array: true # 0..n
  json_attribute :events, Aggregation::Commit::Lido::Descriptive::Event::Base.to_type, array: true # 0..n
  json_attribute :places, Aggregation::Commit::Lido::Concerns::Place.to_type, array: true # 0..n
  json_attribute :objects, Aggregation::Commit::Lido::Concerns::Thing.to_type, array: true # 0..n

end