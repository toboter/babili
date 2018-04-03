# namePlaceSet, eventName, nameActorSet

class Aggregation::Commit::Lido::Concerns::Appellation
  include JsonAttribute::Model
  json_attribute :name, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n
  json_attribute :source, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end