# Title: Custody: Institution / Person
# General: Unambiguous identification, designation and weblink of the institution of custody.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::Name
  include JsonAttribute::Model

  json_attribute :legal_body_id, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :legal_body_name, Aggregation::Commit::Lido::Concerns::Appellation::Base.to_type, array: true # 0..n
  json_attribute :legal_body_url, Aggregation::Commit::Lido::Concerns::Url.to_type, array: true # 0..n

end