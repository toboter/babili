# Title: Measurements Set
# General: The dimensions or other measurements for one aspect of an object / work (e.g., width).
# How to record: May be combined with extent, qualifier, and other sub-elements as necessary.
# The subelements "measurementUnit", "measurementValue" and "measurementType" are mandatory

class Aggregation::Commit::Lido::Descriptive::Identification::Measurement::Set
  include JsonAttribute::Model
  json_attribute :type, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 1..n, uniq: {scope: :lang}
  json_attribute :unit, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 1..n, uniq: {scope: :lang}
  json_attribute :value, Aggregation::Commit::Lido::Concerns::Types::Note.to_type # 1
end