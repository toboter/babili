# Title: Actor
# General: Describes and identifies an actor, i.e. a person, corporation, family or group, containing structured 
# sub-elements for indexing and identification references

class Aggregation::Commit::Lido::Concerns::Actor::Base
  include JsonAttribute::Model

  json_attribute :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :names, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n
  json_attribute :nationalities, Aggregation::Commit::Lido::Concerns::Actor::Nationality.to_type, array: true # 0..n
  json_attribute :vital_date, Aggregation::Commit::Lido::Concerns::Actor::VitalDate.to_type # 0..1
  json_attribute :gender, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
end