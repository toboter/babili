class Aggregation::Event::ApiRequest < Aggregation::Event

  jsonb_accessor :origin,
    request_url: :string

end