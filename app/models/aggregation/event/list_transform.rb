class Aggregation::Event::ListTransform < Aggregation::Event
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes

  self.default_json_container_attribute = 'origin'
  json_attribute :list_id, :integer

end