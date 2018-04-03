

class Aggregation::Commit::Lido::Descriptive::Relation::Related::Base
  include JsonAttribute::Model

  # json_attribute :subject, Aggregation::Commit::Lido::Descriptive::Relation::Subject::Base.to_type, array: true # 0..n
  # json_attribute :related_works, Aggregation::Commit::Lido::Descriptive::Relation::Related::Base.to_type, array: true # 0..n
end