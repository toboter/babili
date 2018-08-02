# Title: GML
# General: Georeferences of the place using the GML specification.
# How to record: Repeat this element only for language variants. Notes For further documentation on GML refer 
# to http://www.opengis.net/gml/.

class Aggregation::Commit::Lido::Concerns::Place::Gml
  include AttrJson::Model

  attr_json :lang, :string
  attr_json :point, :string
  attr_json :line_string, :string
  attr_json :polygon, :string
end