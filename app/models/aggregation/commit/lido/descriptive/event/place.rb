# Title: Event Place
# General: Place specification of the event.

class Aggregation::Commit::Lido::Descriptive::Event::Place
  include JsonAttribute::Model
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Concerns::Place::Base.to_type
end
