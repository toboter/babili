# Title: Cultural context
# General: Name of a culture, cultural context, people, or also a nationality.
# How to record: Preferably using a controlled vocabuarly.

class Aggregation::Commit::Lido::Descriptive::Event::Culture
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :terms, Aggregation::Commit::Lido::Concerns::Types::Term.to_type, array: true # 0..n
end