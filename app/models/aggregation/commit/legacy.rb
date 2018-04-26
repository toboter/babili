class Aggregation::Commit::Legacy < Aggregation::Commit
  store_accessor :data, :payload, :identifier, :changeset
end