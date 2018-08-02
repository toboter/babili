# Title: Source Appellation
# General: The source for the appellation, generally a published source.
# (diplayState, displayObjectMeasurements, measurementValue, measurementUnit, measurementType, displayEvent, 
# displayPlace, displayDate, displayActor, genderActor, displayMaterialsTech, extentMaterialsTech, sourceMaterialsTech,
# displayObject)

class Aggregation::Commit::Lido::Concerns::Types::Note
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :lang, :string
end