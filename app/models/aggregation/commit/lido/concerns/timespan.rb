class Aggregation::Commit::Lido::Concerns::Timespan
  include JsonAttribute::Model
  json_attribute :earliest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
  json_attribute :latest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
end