# subjectConcept, 

class Aggregation::Commit::Lido::Concerns::Concept
  include AttrJson::Model

  attr_json :sortorder, :integer
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end