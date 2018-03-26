# Title: Custody/Repository Location Set
# General: Wrapper for designation and identification of the institution of custody, and possibly an indication 
# of the exact location of the object.

class Aggregation::Commit::Lido::Descriptive::Identification::Repository::Base
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :name, Aggregation::Commit::Lido::Descriptive::Identification::Repository::Name.to_type # 0..1
  json_attribute :work_id, Aggregation::Commit::Lido::Descriptive::Identification::Repository::WorkId.to_type, array: true # 0..n
  json_attribute :location, Aggregation::Commit::Lido::Concerns::Place::Base.to_type # 0..1

end