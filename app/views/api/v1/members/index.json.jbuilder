json.people @members do |person|
  json.merge! person_json(person)
end
