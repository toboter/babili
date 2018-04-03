# Title: Place
# General: Contains structured identifying and indexing information for a geographical entity.
# (repositoryLocation)

class Aggregation::Commit::Lido::Concerns::Place::Base
  include JsonAttribute::Model
  json_attribute :political, :string # city, county, country, civil parish
  json_attribute :geographical, :string # natural environment, landscape
  json_attribute :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :names, Aggregation::Commit::Lido::Concerns::Appellation.to_type, array: true # 0..n
  json_attribute :gml, Aggregation::Commit::Lido::Concerns::Place::Gml.to_type, array: true # 0..n
  json_attribute :part_of, Aggregation::Commit::Lido::Concerns::Place::Base.to_type, array: true # 0..n
  json_attribute :classification, Aggregation::Commit::Lido::Concerns::Place::Classification.to_type, array: true # 0..n

end