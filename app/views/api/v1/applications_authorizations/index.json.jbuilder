json.application_authorizations @authorized_applications do |application|
  json.merge! application_authorization_json(application, current_user: current_user)
end
