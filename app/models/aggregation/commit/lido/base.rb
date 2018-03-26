class Aggregation::Commit::Lido::Base
  include JsonAttribute::Model

  json_attribute :lido_rec_id, :string
  json_attribute :object_published_id, :string
  json_attribute :category, Aggregation::Commit::Lido::Category.to_type # 0..1
  json_attribute :descriptive_metadata, Aggregation::Commit::Lido::Descriptive::Base.to_type, array: true
  json_attribute :administrative_metadata, Aggregation::Commit::Lido::Administrative::Base.to_type, array: true
end