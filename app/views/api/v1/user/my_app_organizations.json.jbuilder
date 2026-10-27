json.organizations @organizations do |organization|
  json.merge! organization_json(organization)
end
