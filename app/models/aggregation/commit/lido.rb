class Aggregation::Commit::Lido < Aggregation::Commit
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  store_accessor :data, :identifier, :changeset
  attr_json :payload, Aggregation::Commit::Lido::Base.to_type, container_attribute: "data"
end