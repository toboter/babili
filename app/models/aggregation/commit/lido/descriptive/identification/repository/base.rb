# Title: Custody/Repository Location Set
# General: Wrapper for designation and identification of the institution of custody, and possibly an indication 
# of the exact location of the object.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::Base
  include AttrJson::Model
  attr_json :type, :string
  attr_json :sortorder, :integer
  attr_json :name, Aggregation::Commit::Lido::Descriptive::Identification::Repository::Name.to_type # 0..1
  attr_json :work_id, Aggregation::Commit::Lido::Descriptive::Identification::Repository::WorkId.to_type, array: true # 0..n
  attr_json :location, Aggregation::Commit::Lido::Concerns::Place::Base.to_type # 0..1

end