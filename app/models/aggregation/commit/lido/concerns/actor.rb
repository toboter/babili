# subjectActor, 

class Aggregation::Commit::Lido::Concerns::Actor
  include JsonAttribute::Model
  json_attribute :sortorder, :integer
  json_attribute :display, Aggregation::Commit::Lido::Concerns::Types::Note.to_type, array: true # 0..n, uniq: {scope: :lang}
  json_attribute :detail, Aggregation::Commit::Lido::Concerns::Actor::Base.to_type # 0..1

end