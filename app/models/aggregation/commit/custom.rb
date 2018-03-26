class Aggregation::Commit::Custom < Aggregation::Commit
  store_accessor :data, :payload, :identifier, :changeset
end