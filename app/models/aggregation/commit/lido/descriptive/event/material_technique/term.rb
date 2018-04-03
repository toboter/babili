# Title: Concept Materials Techniques
# General: A concept to index materials and/or technique.
# How to record: Preferably taken from a published controlled vocabulary.

class Aggregation::Commit::Lido::Descriptive::Event::MaterialTechnique::Term
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end