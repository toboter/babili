# Title: Title or Object Name Set
# General: Wrapper for one title or object name and its source information.
# How to record: Mandatory. If there is no specific title, provide an object name in the appellation value.
# If there is more than one title, repeat the Title Set element. Notes For objects from natural, technical, cultural 
# history e.g. the object name given here and the object typ

class Aggregation::Commit::Lido::Descriptive::Identification::Title
  include AttrJson::Model
  attr_json :type, :string
  attr_json :sortorder, :integer
  attr_json :appellations, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n uniq: {scope: lang}
  attr_json :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end