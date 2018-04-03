# Title: GML
# General: Georeferences of the place using the GML specification.
# How to record: Repeat this element only for language variants. Notes For further documentation on GML refer 
# to http://www.opengis.net/gml/.

class Aggregation::Commit::Lido::Concerns::Place::Gml
  include JsonAttribute::Model

  json_attribute :lang, :string
  json_attribute :point, :string
  json_attribute :line_string, :string
  json_attribute :polygon, :string
end