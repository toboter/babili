class UpdateAppAccessorsJob < ApplicationJob
  queue_as :default

  LOCAL_HOSTS = %w[localhost 127.0.0.1].freeze

  def perform(app_id, person_ids)
    application = Doorkeeper::Application.find(app_id)
    app_update_url = hook_url_for(application)
    # Ping the app for every user with a usable token for it. The client reuses that
    # token to fetch accessibilities from this resource server.
    User.where(person_id: person_ids).find_each do |user|
      user_token = bearer_token_for(application, user)
      unless user_token
        Rails.logger.info("[UpdateAppAccessorsJob] skip user=#{user.id}: no usable OAuth token for app=#{application.id}")
        next
      end

      begin
        response = HttpClient.get(
          app_update_url,
          headers: { Authorization: "Bearer #{user_token}" },
          open_timeout: 10,
          timeout: 30
        )
        Rails.logger.info("[UpdateAppAccessorsJob] user=#{user.id} #{app_update_url} => #{response.status}")
      rescue Faraday::Error => e
        status = e.response && e.response[:status]
        Rails.logger.warn("[UpdateAppAccessorsJob] user=#{user.id} #{app_update_url} failed: #{e.class} #{status} #{e.message}")
      end
    end
  end

  private

  def bearer_token_for(application, user)
    application.access_tokens
      .where(resource_owner_id: user.id, revoked_at: nil)
      .order(id: :desc)
      .detect { |token| token.accessible? && token.scopes.exists?(:public) }
      &.token
  end

  def hook_url_for(application)
    redirects = application.redirect_uri.to_s.lines.map(&:strip).select(&:present?)
    raise ArgumentError, "OAuth application #{application.id} has no redirect_uri" if redirects.empty?

    chosen = preferred_redirect(redirects)
    uri = URI(chosen)
    uri.path = "/api/hooks/update_accessibilities"
    uri.query = nil
    uri.fragment = nil
    uri.to_s
  end

  # Prefer a local callback in development/test so sync hits the running client,
  # not production. Otherwise prefer a non-local URI (production callback first).
  def preferred_redirect(redirects)
    if Rails.env.local?
      redirects.find { |u| LOCAL_HOSTS.include?(URI(u).host) } ||
        redirects.find { |u| URI(u).host.to_s.end_with?(".local") } ||
        redirects.first
    else
      redirects.find { |u| !local_host?(URI(u).host) } || redirects.first
    end
  end

  def local_host?(host)
    host = host.to_s
    LOCAL_HOSTS.include?(host) || host.end_with?(".local")
  end
end
