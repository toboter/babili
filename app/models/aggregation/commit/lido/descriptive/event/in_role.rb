# Title: Role in Event
# General: The role played within this event by the described entity.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Event::InRole
  include JsonAttribute::Model
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Concept.to_type
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Term.to_type
end