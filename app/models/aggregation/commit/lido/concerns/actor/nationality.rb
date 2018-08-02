# Title: Nationality Actor
# General: National or cultural affiliation of the person or corporate body.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Concerns::Actor::Nationality
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end