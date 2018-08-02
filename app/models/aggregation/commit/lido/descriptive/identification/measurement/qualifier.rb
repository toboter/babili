# Title: Qualifier Measurements
# General: A word or phrase that elaborates on the nature of the measurements of the object / work when necessary, 
# e.g. when the measurements are approximate.
# How to record: Example values: approximate, sight, maximum, larges, smallest, average, variable, assembled, 
# before restoration, before restoration, at corners, rounded, framed, and with base.

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Qualifier
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :value, :string
end