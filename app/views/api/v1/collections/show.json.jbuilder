json.collection do
  json.merge! collection_json(@collection, current_user: current_user)
end
