# Title: Date
# General: A year or exact date that broadly delimits the beginning of an implied date span.
# How to record: General format: YYYY[-MM[-DD]]. Format is according to ISO 8601. This may include date and time specification.

class Aggregation::Commit::Lido::Concerns::Date
  include JsonAttribute::Model
  json_attribute :value, :string
  json_attribute :label, :string
  json_attribute :type, :string
  json_attribute :source, :string
end