# Title: Event Actor
# General: Wrapper for display and index elements for an actor with role information (participating or 
# being present in the event).
# How to record: For multiple actors repeat the element.

class Aggregation::Commit::Lido::Descriptive::Event::Actor::Base
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :detail, Aggregation::Commit::Lido::Descriptive::Event::Actor::Detail.to_type # 0..1

end