
class Aggregation::Commit::Lido::Concerns::Thing::Base
  include JsonAttribute::Model

  json_attribute :web_urls, Aggregation::Commit::Lido::Concerns::Types::Url.to_type, array: true # 0..n
  json_attribute :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :notes, Aggregation::Commit::Lido::Concerns::Types::TypeValue.to_type, array: true # 0..n

end