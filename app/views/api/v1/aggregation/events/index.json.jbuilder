json.events @events do |event|
  json.merge! aggregation_event_json(event)
end
json.meta @meta if @meta
