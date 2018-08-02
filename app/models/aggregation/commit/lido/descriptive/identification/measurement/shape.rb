# Title: Shape Measurements
# General: The shape of an object / work. Used for unusual shapes (e.g., an oval painting).
# How to record: Example values: oval, round, square, rectangular, and irregular

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Shape
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :value, :string
end