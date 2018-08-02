# Title: Role in Event
# General: The role played within this event by the described entity.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Event::InRole
  include AttrJson::Model
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end