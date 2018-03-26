# Title: Extent Measurements
# General: An explanation of the part of the object / work being measured included, when necessary, for clarity.
# How to record: Example values: overall, components, sheet, plate mark, chain lines, pattern repeat, lid, base, 
# laid lines, folios, leaves, columns per page, lines per page, tessera, footprint, panel, interior, mat, 
# window of mat, secondary support, frame, and mount

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Extent
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :value, :string
end