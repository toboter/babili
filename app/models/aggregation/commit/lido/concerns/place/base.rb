# Title: Place
# General: Contains structured identifying and indexing information for a geographical entity.
# (repositoryLocation)

class Aggregation::Commit::Lido::Concerns::Place::Base
  include AttrJson::Model
  attr_json :political, :string # city, county, country, civil parish
  attr_json :geographical, :string # natural environment, landscape
  attr_json :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :names, Aggregation::Commit::Lido::Concerns::Appellation.to_type, array: true # 0..n
  attr_json :gml, Aggregation::Commit::Lido::Concerns::Place::Gml.to_type, array: true # 0..n
  attr_json :part_of, Aggregation::Commit::Lido::Concerns::Place::Base.to_type, array: true # 0..n
  attr_json :classification, Aggregation::Commit::Lido::Concerns::Place::Classification.to_type, array: true # 0..n

end