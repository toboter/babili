# Title: Role Actor
# General: Role of the Actor in the event.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Event::Actor::Role
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end