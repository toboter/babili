class Aggregation::Commit::Lido::Concerns::Timespan
  include AttrJson::Model
  attr_json :earliest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
  attr_json :latest, Aggregation::Commit::Lido::Concerns::Types::Date.to_type # 0..1
end