# Title: Description/Descriptive Note Set
# General: Wrapper for a description of the object, including description identifer, descriptive note and sources.
# How to record: Includes usually a relatively brief essay-like text that describes the content and context of 
# the object / work, including comments and an interpretation that may supplement, qualify, or explain the
# physical characteristics, subject, circumstances of creation or discovery, or other information about it.
# If there is more than one descriptive note, repeat this element. Notes A reference to a text resource holding the 
# description may be given in description identifier.

class Aggregation::Commit::Lido::Descriptive::Identification::Description
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer

  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :notes, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n uniq: {scope: lang}
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
end