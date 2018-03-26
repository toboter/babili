# namePlaceSet, eventName

class Aggregation::Commit::Lido::Concerns::Appellation::Base
  include JsonAttribute::Model
  json_attribute :name, Aggregation::Commit::Lido::Concerns::Appellation::Name.to_type, array: true # 1..n
  json_attribute :source, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
end