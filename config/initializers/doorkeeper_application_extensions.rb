module DoorkeeperApplicationExtension
  extend ActiveSupport::Concern

  included do
    has_many :accessibilities, dependent: :delete_all, class_name: 'OauthAccessibility', foreign_key: 'oauth_application_id'
    has_many :organization_accessors, through: :accessibilities, source: :accessor, source_type: 'Organization'
    has_many :user_accessors, through: :accessibilities, source: :accessor, source_type: 'User'
  end
end

Doorkeeper::Application.send :include, DoorkeeperApplicationExtension