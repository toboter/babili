# Title: Date
# General: A year or exact date that broadly delimits the beginning of an implied date span.
# How to record: General format: YYYY[-MM[-DD]]. Format is according to ISO 8601. This may include date and time specification.

class Aggregation::Commit::Lido::Concerns::Types::Date
  include AttrJson::Model
  attr_json :value, :string
  attr_json :label, :string
  attr_json :type, :string
  attr_json :source, :string
end