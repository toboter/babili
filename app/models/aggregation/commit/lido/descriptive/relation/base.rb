# Title: Object Relation Wrapper
# General: Wrapper for infomation about related topics and works, collections, etc.
# Notes: This includes visual contents and all associated entities the object is about.

class Aggregation::Commit::Lido::Descriptive::Relation::Base
  include AttrJson::Model

  attr_json :subject, Aggregation::Commit::Lido::Descriptive::Relation::Subject::Base.to_type, array: true # 0..n
  attr_json :related_works, Aggregation::Commit::Lido::Descriptive::Relation::Related::Base.to_type, array: true # 0..n
end