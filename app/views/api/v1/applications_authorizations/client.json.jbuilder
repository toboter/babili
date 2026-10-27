json.application_authorization_client do
  json.merge! application_authorization_client_json(@authorized_application, current_user: current_user)
end
