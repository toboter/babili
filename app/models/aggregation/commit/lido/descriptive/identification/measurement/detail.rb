# Title: Object Measurement
# General: Structured measurement information about the dimensions, size, or scale of the object / work.
# Notes: It may also include the parts of a complex object / work, series, or collection.

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Detail
  include JsonAttribute::Model

  json_attribute :sets, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Set.to_type, array: true # 0..n
  json_attribute :extents, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Extent.to_type, array: true # 0..n
  json_attribute :qualifiers, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Qualifier.to_type, array: true # 0..n
  json_attribute :formats, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Format.to_type, array: true # 0..n
  json_attribute :shapes, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Shape.to_type, array: true # 0..n
  json_attribute :scales, Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Scale.to_type, array: true # 0..n

end