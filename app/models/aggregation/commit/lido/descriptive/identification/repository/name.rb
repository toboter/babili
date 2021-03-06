# Title: Custody: Institution / Person
# General: Unambiguous identification, designation and weblink of the institution of custody.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::Name
  include AttrJson::Model

  attr_json :legal_body_id, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :legal_body_name, Aggregation::Commit::Lido::Concerns::Appellation.to_type, array: true # 0..n
  attr_json :legal_body_url, Aggregation::Commit::Lido::Concerns::Types::Url.to_type, array: true # 0..n

end