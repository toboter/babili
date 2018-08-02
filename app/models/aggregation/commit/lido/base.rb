class Aggregation::Commit::Lido::Base
  include AttrJson::Model

  attr_json :lido_rec_id, :string
  attr_json :object_published_id, :string
  attr_json :category, Aggregation::Commit::Lido::Category.to_type # 0..1
  attr_json :descriptive_metadata, Aggregation::Commit::Lido::Descriptive::Base.to_type, array: true
  attr_json :administrative_metadata, Aggregation::Commit::Lido::Administrative::Base.to_type, array: true
end