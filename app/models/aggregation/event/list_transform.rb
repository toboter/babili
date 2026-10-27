class Aggregation::Event::ListTransform < Aggregation::Event
  include AttrJson::Record
  include AttrJson::Record::QueryScopes
  attr_json_config(default_container_attribute: :origin)

  def self.model_name
    Aggregation::Event.model_name
  end

  attr_json :list_id, :integer

end