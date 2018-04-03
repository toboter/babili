# Title: Object/Work Type
# General: The specific kind of object / work being described.
# How to record: Preferably taken from a published controlled vocabulary. For a collection, include repeating 
# instances for identifying all of or the most important items in the collection.

class Aggregation::Commit::Lido::Descriptive::Classification::WorkType
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end