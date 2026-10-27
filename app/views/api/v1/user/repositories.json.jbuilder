json.collections @collections do |collection|
  json.merge! collection_json(collection, current_user: current_user)
end
