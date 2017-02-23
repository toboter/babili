module DoorkeeperApplicationExtension
  extend ActiveSupport::Concern

  included do
    has_many :accessibilities, dependent: :delete_all, class_name: 'OauthAccessibility', foreign_key: 'oauth_application_id'
    has_many :projects, through: :accessibilities, class_name: 'Project'
  end
end

Doorkeeper::Application.send :include, DoorkeeperApplicationExtension