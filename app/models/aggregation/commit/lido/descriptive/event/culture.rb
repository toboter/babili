# Title: Cultural context
# General: Name of a culture, cultural context, people, or also a nationality.
# How to record: Preferably using a controlled vocabuarly.

class Aggregation::Commit::Lido::Descriptive::Event::Culture
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :concept, Aggregation::Commit::Lido::Concerns::Concept.to_type
  json_attribute :term, Aggregation::Commit::Lido::Concerns::Term.to_type
end