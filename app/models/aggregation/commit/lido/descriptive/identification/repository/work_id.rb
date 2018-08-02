# Title: Custody: Identification number
# General: An unambiguous numeric or alphanumeric identification number, assigned to the object by the institution 
# of custody.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::WorkId
  include AttrJson::Model

  attr_json :value, :string
  attr_json :type, :string
  attr_json :sortorder, :integer
  attr_json :label, :string

end