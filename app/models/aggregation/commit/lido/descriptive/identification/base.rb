# Title:  Object Identification Wrapper
# General: A Wrapper for information that identifies the object.

class Aggregation::Commit::Lido::Descriptive::Identification::Base
  include AttrJson::Model
  attr_json :titles, Aggregation::Commit::Lido::Descriptive::Identification::Title.to_type, array: true # 1..n
  attr_json :inscriptions, Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Base.to_type, array: true # 0..n
  attr_json :respositories, Aggregation::Commit::Lido::Descriptive::Identification::Repository::Base.to_type, array: true # 0..n
  attr_json :display_state, Aggregation::Commit::Lido::Descriptive::Identification::DisplayState.to_type # 0..1
  attr_json :descriptions, Aggregation::Commit::Lido::Descriptive::Identification::Description.to_type, array: true # 0..n
  attr_json :measurements, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Base.to_type, array: true # 0..n

end