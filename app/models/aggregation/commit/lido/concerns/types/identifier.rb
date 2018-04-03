# Title: Concept Identifier
# General: A unique identifier for the concept.
# How to record: Preferably taken from and linking to a published controlled vocabulary.

# Titles: Legal Body ID 
# General: Unambiguous id

class Aggregation::Commit::Lido::Concerns::Types::Identifier
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :pref, :string # preferred, alternate
  json_attribute :type, :string
  json_attribute :source, :string
end