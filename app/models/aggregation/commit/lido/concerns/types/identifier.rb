# Title: Concept Identifier
# General: A unique identifier for the concept.
# How to record: Preferably taken from and linking to a published controlled vocabulary.

# Titles: Legal Body ID 
# General: Unambiguous id

class Aggregation::Commit::Lido::Concerns::Types::Identifier
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :pref, :string # preferred, alternate
  attr_json :type, :string
  attr_json :source, :string
end