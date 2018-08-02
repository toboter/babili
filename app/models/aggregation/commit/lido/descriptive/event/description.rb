# Title: Event Description
# General: Wrapper for a description of the event, including description identifer, descriptive note of the event 
# and its sources. 
# How to record: If there is more than one descriptive note, repeat this element.

class Aggregation::Commit::Lido::Descriptive::Event::Description
  include AttrJson::Model
  attr_json :type, :string
  attr_json :sortorder, :integer
  
  attr_json :concepts, Aggregation::Commit::Lido::Concerns::Types::Identifier.to_type, array: true # 0..n
  attr_json :notes, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n uniq: {scope: lang}
  attr_json :sources, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n
end