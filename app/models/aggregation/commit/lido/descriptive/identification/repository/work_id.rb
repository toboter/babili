# Title: Custody: Identification number
# General: An unambiguous numeric or alphanumeric identification number, assigned to the object by the institution 
# of custody.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::WorkId
  include JsonAttribute::Model

  json_attribute :value, :string
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :label, :string

end