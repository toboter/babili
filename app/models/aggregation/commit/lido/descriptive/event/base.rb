# Title: Event Set
# General: Wrapper for the display and index elements for events (e.g. creation, find, and use), 
# in which the object participated.
# How to record: For multiple events repeat the element.

class Aggregation::Commit::Lido::Descriptive::Event::Base
  include AttrJson::Model
  attr_json :sortorder, :integer
  attr_json :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :detail, Aggregation::Commit::Lido::Descriptive::Event::Detail.to_type # 0..1

end