# subjectPlace, 

class Aggregation::Commit::Lido::Concerns::Place
  include AttrJson::Model

  attr_json :sortorder, :integer
  attr_json :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  attr_json :detail, Aggregation::Commit::Lido::Concerns::Place::Base.to_type
end
