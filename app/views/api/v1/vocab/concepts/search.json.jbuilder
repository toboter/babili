json.concepts @results do |concept|
  json.merge! concept_json(concept)
end
json.meta @meta if @meta
