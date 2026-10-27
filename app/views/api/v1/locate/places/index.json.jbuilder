json.places @places do |place|
  json.merge! place_json(place)
end
json.meta @meta if @meta
