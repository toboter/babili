# Title: Cultural context
# General: Name of a culture, cultural context, people, or also a nationality.
# How to record: Preferably using a controlled vocabuarly.

class Aggregation::Commit::Lido::Descriptive::Event::Culture
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end