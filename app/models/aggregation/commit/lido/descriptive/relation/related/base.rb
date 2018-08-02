

class Aggregation::Commit::Lido::Descriptive::Relation::Related::Base
  include AttrJson::Model

  # attr_json :subject, Aggregation::Commit::Lido::Descriptive::Relation::Subject::Base.to_type, array: true # 0..n
  # attr_json :related_works, Aggregation::Commit::Lido::Descriptive::Relation::Related::Base.to_type, array: true # 0..n
end