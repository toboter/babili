# Title: Display State/Edition Wrapper
# General: A wrapper for the state and edition of the object / work.

class Aggregation::Commit::Lido::Descriptive::Identification::DisplayState
  include JsonAttribute::Model

  json_attribute :states, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
  json_attribute :editions, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
end