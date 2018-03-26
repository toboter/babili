# Title: Period
# General: A period in which the event happened.
# How to record: Preferably taken from a published controlled vocabulary. Repeat this element only for indicating 
# an earliest and latest period delimiting the event. Notes Period concepts have delimiting character in time and space.

class Aggregation::Commit::Lido::Descriptive::Event::Period
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Concept.to_type
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Term.to_type
end