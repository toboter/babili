
class Aggregation::Commit::Lido::Concerns::Thing::Base
  include AttrJson::Model

  attr_json :web_urls, Aggregation::Commit::Lido::Concerns::Types::Url.to_type, array: true # 0..n
  attr_json :identifiers, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :notes, Aggregation::Commit::Lido::Concerns::Types::TypeValue.to_type, array: true # 0..n

end