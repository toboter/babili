class UpdateClientAppUserAccessibilitiesJob < ApplicationJob
  queue_as :default
  require 'uri'
  require 'rest-client'
  require 'json'

  def perform(application, user_ids)
    application = Doorkeeper::Application.find(application)
    app_uri = URI(application.redirect_uri)
    app_update_url = "#{app_uri.scheme}://#{app_uri.host}#{':'+app_uri.port.to_s if app_uri.port}/api/hooks/update_accessibilities"
    User.where(id: user_ids).each do |user|
      user_token = application.access_tokens.where(resource_owner_id: user).last.try(:token)
      response = RestClient.get(app_update_url, {:Authorization => "Bearer #{user_token}"}) if user_token
      puts response
    end
  end
end
