# Title: Object Measurements Set
# General: Wrapper for display and index elements for object / work measurements.
# How to record: If multiple parts of the object / work are measured repeat this element.

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Base
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :detail, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Detail.to_type # 0..1

end