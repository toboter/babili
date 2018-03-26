# Title: Shape Measurements
# General: The shape of an object / work. Used for unusual shapes (e.g., an oval painting).
# How to record: Example values: oval, round, square, rectangular, and irregular

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Shape
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :value, :string
end