# Title: Inscription Description
# General: Wrapper for a description of the inscription, including description identifer, descriptive note 
# of the inscription and sources.

class Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Description
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Concept.to_type, array: true # 0..n
  json_attribute :notes, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n uniq: {scope: lang}
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n
end