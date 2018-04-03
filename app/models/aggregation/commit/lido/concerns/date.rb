# subjectDate

class Aggregation::Commit::Lido::Concerns::Date
  include JsonAttribute::Model

  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :timespan, Aggregation::Commit::Lido::Concerns::Timespan.to_type # 0..1

end