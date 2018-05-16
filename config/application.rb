require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Babili
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sidekiq
    
    config.to_prepare do
      # Only Applications list
      Doorkeeper::ApplicationsController.layout "developer"
    
      # Only Authorization endpoint
      Doorkeeper::AuthorizationsController.layout "application"
    
      # Only Authorized Applications
      Doorkeeper::AuthorizedApplicationsController.layout "settings"
    end

    # Rack::Cors provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications.
    # This will allow GET, POST or OPTIONS requests from any origin on any resource.
    # cf https://github.com/cyu/rack-cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

  end
end
