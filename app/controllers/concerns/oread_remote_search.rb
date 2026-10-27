# Shared remote collection search used by HTML + API search controllers.
# Always fails soft: unreachable Oread hosts must not block local Searchkick results.
module OreadRemoteSearch
  extend ActiveSupport::Concern

  REMOTE_OPEN_TIMEOUT = 2
  REMOTE_READ_TIMEOUT = 8

  private

  def search_oread_remotes(query)
    repos =
      if user_signed_in?
        current_user.oread_enrolled_applications
      else
        Oread::Application.where(enroll_users_default: true)
      end

    results = []
    failures = []

    Array(repos).each do |repo|
      token =
        if user_signed_in?
          repo.access_tokens.where(resource_owner: current_user).order(id: :desc).first
        end

      if user_signed_in? && token.blank?
        failures << "#{repo.name}: no API token (open ADGB while signed in to sync one)"
        next
      end

      Array(repo.collection_classes).each do |rclass|
        configured_url = "#{rclass.repo_api_url}?q=#{ERB::Util.url_encode(query)}"
        url = localize_oread_request_url(configured_url)
        begin
          headers = {}
          if token
            type = token.token_type.presence || "Token"
            headers[:Authorization] = "#{type} #{token.token}"
          end

          response = RestClient::Request.execute(
            method: :get,
            url: url,
            headers: headers,
            open_timeout: REMOTE_OPEN_TIMEOUT,
            timeout: REMOTE_READ_TIMEOUT
          )
          parsed = JSON.parse(response.body)
          results << parsed if parsed.present?
        rescue RestClient::Exception, SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH,
               Errno::ENETUNREACH, Errno::ETIMEDOUT, Net::OpenTimeout, Net::ReadTimeout,
               Timeout::Error, JSON::ParserError, URI::InvalidURIError => e
          failures << "#{configured_url} (#{e.class})"
          Rails.logger.warn("[OreadRemoteSearch] #{url} failed: #{e.class}: #{e.message}")
        end
      end
    end

    [results, failures]
  end

  # Browser URLs use *.local hosts; server-side DNS for `.local` often stalls on mDNS.
  # In development, call loopback directly so Babili can reach local ADGB.
  def localize_oread_request_url(url)
    return url unless Rails.env.development?

    uri = URI.parse(url)
    return url unless uri.host&.end_with?(".local")

    uri.host = "127.0.0.1"
    uri.to_s
  rescue URI::InvalidURIError
    url
  end
end
