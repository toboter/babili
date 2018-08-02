# Title: Actor
# General: Describes and identifies an actor, i.e. a person, corporation, family or group, containing structured 
# sub-elements for indexing and identification references

class Aggregation::Commit::Lido::Concerns::Actor::Base
  include AttrJson::Model

  attr_json :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :names, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n
  attr_json :nationalities, Aggregation::Commit::Lido::Concerns::Actor::Nationality.to_type, array: true # 0..n
  attr_json :vital_date, Aggregation::Commit::Lido::Concerns::Actor::VitalDate.to_type # 0..1
  attr_json :gender, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
end