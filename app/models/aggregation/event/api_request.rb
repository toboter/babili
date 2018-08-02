class Aggregation::Event::ApiRequest < Aggregation::Event
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes

  self.default_json_container_attribute = 'origin'
  json_attribute :request_url, :string


  def process
    return true
  end

end