json.entries @results do |entry|
  json.merge! entry_json(entry)
end
