# Title: Event Description
# General: Wrapper for a description of the event, including description identifer, descriptive note of the event 
# and its sources. 
# How to record: If there is more than one descriptive note, repeat this element.

class Aggregation::Commit::Lido::Descriptive::Event::Description
  include JsonAttribute::Model
  json_attribute :type, :string
  json_attribute :sortorder, :integer
  
  json_attribute :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  json_attribute :notes, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n uniq: {scope: lang}
  json_attribute :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end