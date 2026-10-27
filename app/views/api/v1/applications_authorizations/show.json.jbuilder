json.application_authorization do
  json.merge! application_authorization_json(@authorized_application, current_user: current_user)
end
