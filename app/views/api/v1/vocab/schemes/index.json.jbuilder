json.concept_schemes @schemes do |scheme|
  json.merge! concept_scheme_json(scheme)
end
json.meta @meta if @meta
