# subjectPlace, 

class Aggregation::Commit::Lido::Concerns::Place
  include JsonAttribute::Model

  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Concerns::Place::Base.to_type
end
