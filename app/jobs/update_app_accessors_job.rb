class UpdateAppAccessorsJob < ApplicationJob
  queue_as :default
  require 'uri'
  require 'json'

  def perform(app_id, person_ids)
    application = Doorkeeper::Application.find(app_id)
    # Doorkeeper stores multiple redirect URIs separated by newlines.
    redirect = application.redirect_uri.to_s.lines.map(&:strip).find(&:present?)
    raise ArgumentError, "OAuth application #{app_id} has no redirect_uri" if redirect.blank?

    app_uri = URI(redirect)
    app_update_url = "#{app_uri.scheme}://#{app_uri.host}#{':'+app_uri.port.to_s if app_uri.port}/api/hooks/update_accessibilities"
    # Ping the app for every user with a token for it, with the token in the header to reuse it to check the accessibilities 
    # on this resource server.
    User.where(person_id: person_ids).each do |user|
      user_token = application.access_tokens.where(resource_owner_id: user).last.try(:token)
      next unless user_token

      response = HttpClient.get(
        app_update_url,
        headers: { Authorization: "Bearer #{user_token}" },
        open_timeout: 10,
        timeout: 30
      )
      Rails.logger.info("[UpdateAppAccessorsJob] #{app_update_url} => #{response.status}")
    end
  end
end
