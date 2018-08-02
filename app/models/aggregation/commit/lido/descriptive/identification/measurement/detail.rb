# Title: Object Measurement
# General: Structured measurement information about the dimensions, size, or scale of the object / work.
# Notes: It may also include the parts of a complex object / work, series, or collection.

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Detail
  include AttrJson::Model

  attr_json :sets, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Set.to_type, array: true # 0..n
  attr_json :extents, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Extent.to_type, array: true # 0..n
  attr_json :qualifiers, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Qualifier.to_type, array: true # 0..n
  attr_json :formats, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Format.to_type, array: true # 0..n
  attr_json :shapes, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Shape.to_type, array: true # 0..n
  attr_json :scales, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Scale.to_type, array: true # 0..n

end