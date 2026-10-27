json.user do
  json.merge! user_json(@user || current_user, current_user: current_user)
end
