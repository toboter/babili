json.events @events do |event|
  json.merge! zensus_event_json(event)
end
json.meta @meta if @meta
