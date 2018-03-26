# Title: Event Set
# General: Wrapper for the display and index elements for events (e.g. creation, find, and use), 
# in which the object participated.
# How to record: For multiple events repeat the element.

class Aggregation::Commit::Lido::Descriptive::Event::Base
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Descriptive::Event::Detail.to_type # 0..1

end