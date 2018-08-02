# Title: Concept Materials Techniques
# General: A concept to index materials and/or technique.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Term
  include AttrJson::Model
  attr_json :type, :string
  attr_json :sortorder, :integer
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end