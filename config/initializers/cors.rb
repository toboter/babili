# config/initializers/cors.rb
# Rack::Cors provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
# This will allow GET, POST or OPTIONS requests from any origin on any resource.
# cf https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true, logger: (-> { Rails.logger }) do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end