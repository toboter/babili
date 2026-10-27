json.oread_applications @oread_applications do |application|
  json.merge! oread_application_json(application, current_user: current_user)
end
