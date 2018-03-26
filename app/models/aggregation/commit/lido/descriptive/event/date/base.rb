# Title: Event Date
# General: Date specification of the event.

class Aggregation::Commit::Lido::Descriptive::Event::Date::Base
  include JsonAttribute::Model

  json_attribute :display, Aggregation::Commit::Lido::Concerns::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Descriptive::Event::Date::Detail.to_type # 0..1

end