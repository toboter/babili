# subjectDate

class Aggregation::Commit::Lido::Concerns::Date
  include AttrJson::Model

  attr_json :sortorder, :integer
  attr_json :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :timespan, Aggregation::Commit::Lido::Concerns::Timespan.to_type # 0..1

end