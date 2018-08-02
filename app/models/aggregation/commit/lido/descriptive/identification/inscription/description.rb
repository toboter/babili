# Title: Inscription Description
# General: Wrapper for a description of the inscription, including description identifer, descriptive note 
# of the inscription and sources.

class Aggregation::Commit::Lido::Descriptive::Identification::Inscription::Description
  include AttrJson::Model
  attr_json :type, :string
  attr_json :sortorder, :integer
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :notes, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n uniq: {scope: lang}
  attr_json :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end