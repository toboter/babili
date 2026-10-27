json.memberships @memberships do |membership|
  json.merge! membership_json(membership)
end
