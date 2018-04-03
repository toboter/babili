# Title: Event Actor
# General: Wrapper for display and index elements for an actor with role information (participating or 
# being present in the event).
# How to record: For multiple actors repeat the element.

class Aggregation::Commit::Lido::Descriptive::Event::Actor::Base
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Descriptive::Event::Actor::Detail.to_type # 0..1

end