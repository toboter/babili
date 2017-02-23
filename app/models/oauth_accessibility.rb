class OauthAccessibility < ApplicationRecord
  belongs_to :oauth_application, class_name: 'Doorkeeper::Application', foreign_key: 'oauth_application_id'
  belongs_to :project

  validates :oauth_application_id, :project_id, :creator_id, presence: true
  validates :oauth_application_id, uniqueness: { scope: :project_id }
end
