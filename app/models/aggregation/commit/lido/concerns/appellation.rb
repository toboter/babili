# namePlaceSet, eventName, nameActorSet

class Aggregation::Commit::Lido::Concerns::Appellation
  include AttrJson::Model
  attr_json :name, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n
  attr_json :source, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end