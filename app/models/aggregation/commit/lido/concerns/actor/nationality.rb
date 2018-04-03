# Title: Nationality Actor
# General: National or cultural affiliation of the person or corporate body.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Concerns::Actor::Nationality
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end