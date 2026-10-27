json.applications_grants @grants do |grant|
  json.merge! applications_grant_json(grant)
end
