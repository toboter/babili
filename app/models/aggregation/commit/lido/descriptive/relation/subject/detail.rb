# Title: Subject
# General: Contains sub-elements for a structured subject description. These identify, describe, and/or 
# interpret what is depicted in and by an object / work or what it is about.

class Aggregation::Commit::Lido::Descriptive::Relation::Subject::Detail
  include AttrJson::Model

  attr_json :extent, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  attr_json :actors, Aggregation::Commit::Lido::Concerns::Actor.to_type, array: true # 0..n
  attr_json :dates, Aggregation::Commit::Lido::Concerns::Date.to_type, array: true # 0..n
  attr_json :events, Aggregation::Commit::Lido::Descriptive::Event::Base.to_type, array: true # 0..n
  attr_json :places, Aggregation::Commit::Lido::Concerns::Place.to_type, array: true # 0..n
  attr_json :objects, Aggregation::Commit::Lido::Concerns::Thing.to_type, array: true # 0..n

end