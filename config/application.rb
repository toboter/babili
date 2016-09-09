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
    
    config.to_prepare do
      # Only Applications list
      Doorkeeper::ApplicationsController.layout "application"
    
      # Only Authorization endpoint
      Doorkeeper::AuthorizationsController.layout "application"
    
      # Only Authorized Applications
      Doorkeeper::AuthorizedApplicationsController.layout "application"
    end
  end
end
