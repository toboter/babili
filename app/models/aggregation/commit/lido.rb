class Aggregation::Commit::Lido < Aggregation::Commit
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  store_accessor :data, :identifier, :changeset
  json_attribute :payload, Aggregation::Commit::Lido::Base.to_type, container_attribute: "data"
end