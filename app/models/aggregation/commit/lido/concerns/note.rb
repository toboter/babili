# Title: Source Appellation
# General: The source for the appellation, generally a published source.
# (diplayState, displayObjectMeasurements, measurementValue, measurementUnit, measurementType, displayEvent, 
# displayPlace, displayDate)

class Aggregation::Commit::Lido::Concerns::Note
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :lang, :string
end