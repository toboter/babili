# Rack::Cors — Cross-Origin Resource Sharing for the Babili API / assets.
# Production: only babylon-online.org hosts (adgb, api, www/babili, …).
# Development: local *.dev.local hosts used with ADGB.

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: Rails.env.development?, logger: (-> { Rails.logger }) do
  allow do
    if Rails.env.production?
      origins(
        /\Ahttps:\/\/([a-z0-9-]+\.)?babylon-online\.org\z/i
      )
    else
      origins(
        /\Ahttp:\/\/([a-z0-9-]+\.)?dev\.local(:\d+)?\z/i,
        /\Ahttp:\/\/localhost(:\d+)?\z/i,
        /\Ahttp:\/\/127\.0\.0\.1(:\d+)?\z/i
      )
    end

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: false
  end
end
