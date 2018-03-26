# Title:  Object Identification Wrapper
# General: A Wrapper for information that identifies the object.

class Aggregation::Commit::Lido::Descriptive::Identification::Base
  include JsonAttribute::Model
  json_attribute :titles, Aggregation::Commit::Lido::Descriptive::Identification::Title.to_type, array: true # 1..n
  json_attribute :inscriptions, Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Base.to_type, array: true # 0..n
  json_attribute :respositories, Aggregation::Commit::Lido::Descriptive::Identification::Repository::Base.to_type, array: true # 0..n
  json_attribute :display_state, Aggregation::Commit::Lido::Descriptive::Identification::DisplayState.to_type # 0..1
  json_attribute :descriptions, Aggregation::Commit::Lido::Descriptive::Identification::Description.to_type, array: true # 0..n
  json_attribute :measurements, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Base.to_type, array: true # 0..n

end