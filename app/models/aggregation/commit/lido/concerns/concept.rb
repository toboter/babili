# subjectConcept, 

class Aggregation::Commit::Lido::Concerns::Concept
  include JsonAttribute::Model

  json_attribute :sortorder, :integer
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end