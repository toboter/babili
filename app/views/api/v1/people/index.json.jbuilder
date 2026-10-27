json.people @people do |person|
  json.merge! person_json(person)
end
