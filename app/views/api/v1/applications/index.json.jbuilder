json.applications @applications do |application|
  json.merge! application_json(application)
end
