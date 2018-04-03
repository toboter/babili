# Title: Title or Object Name Set
# General: Wrapper for one title or object name and its source information.
# How to record: Mandatory. If there is no specific title, provide an object name in the appellation value.
# If there is more than one title, repeat the Title Set element. Notes For objects from natural, technical, cultural 
# history e.g. the object name given here and the object typ

class Aggregation::Commit::Lido::Descriptive::Identification::Title
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  json_attribute :appellations, Aggregation::Commit::Lido::Concerns::Types::Name.to_type, array: true # 1..n uniq: {scope: lang}
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end