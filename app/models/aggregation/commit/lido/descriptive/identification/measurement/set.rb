# Title: Measurements Set
# General: The dimensions or other measurements for one aspect of an object / work (e.g., width).
# How to record: May be combined with extent, qualifier, and other sub-elements as necessary.
# The subelements "measurementUnit", "measurementValue" and "measurementType" are mandatory

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Set
  include AttrJson::Model
  attr_json :type, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 1..n, uniq: {scope: :lang}
  attr_json :unit, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 1..n, uniq: {scope: :lang}
  attr_json :value, Aggregation::Commit::Lido::Concerns::Types::Note.to_type # 1
end