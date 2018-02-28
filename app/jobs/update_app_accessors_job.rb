class UpdateAppAccessorsJob < ApplicationJob
  queue_as :default
  require 'uri'
  require 'rest-client'
  require 'json'

  def perform(app_id, person_ids)
    application = Doorkeeper::Application.find(app_id)
    app_uri = URI(application.redirect_uri)
    app_update_url = "#{app_uri.scheme}://#{app_uri.host}#{':'+app_uri.port.to_s if app_uri.port}/api/hooks/update_accessibilities"
    # Ping the app for every user with a token for it, with the token in the header to reuse it to check the accessibilities 
    # on this resource server.
    User.where(person_id: person_ids).each do |user|
      user_token = application.access_tokens.where(resource_owner_id: user).last.try(:token)
      response = RestClient.get(app_update_url, {:Authorization => "Bearer #{user_token}"}) if user_token
      puts response
    end
  end
end
