# Title: Format Measurements
# General: The configuration of an object / work, including technical formats. Used as necessary.
# How to record: Example values: Vignette, VHS, IMAX, and DOS

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Format
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :value, :string
end