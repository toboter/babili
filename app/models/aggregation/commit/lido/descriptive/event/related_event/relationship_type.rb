# Title: Related Event Relationship Type
# General: A term describing the nature of the relationship between the described event and the related event.
# How to record: Example values: part of, influence of, related to. Indicate a term characterizing the relationship 
# from the perspective of the currently described event towards the related event.
# Preferably taken from a published controlled vocabulary.
# Notes: For implementation of the data, note that relationships are conceptually reciprocal, but the 
# Relationship Type is often different on either side of the relationship.

class Aggregation::Commit::Lido::Descriptive::Event::RelatedEvent::RelationshipType
  include AttrJson::Model

  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end