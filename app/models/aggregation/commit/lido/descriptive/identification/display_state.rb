# Title: Display State/Edition Wrapper
# General: A wrapper for the state and edition of the object / work.

class Aggregation::Commit::Lido::Descriptive::Identification::DisplayState
  include AttrJson::Model

  attr_json :states, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  attr_json :editions, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
  attr_json :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end