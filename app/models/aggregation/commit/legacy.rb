class Aggregation::Commit::Legacy < Aggregation::Commit
  store_accessor :data, :payload, :changeset
end