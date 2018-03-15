class Aggregation::Event::ListTransform < Aggregation::Event

  jsonb_accessor :origin,
    list_id: :integer

end