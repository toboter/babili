class PersonalAccessToken < ApplicationRecord
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes

  has_secure_token :access_token

  self.default_json_container_attribute = 'scope'
  json_attribute :collections, :boolean
  json_attribute :search, :boolean
  json_attribute :notifications, :boolean
  json_attribute :organizations, :boolean
  json_attribute :user_profile, :boolean
  json_attribute :user_email, :boolean

  validates :resource_owner_id, :description, presence: true

  belongs_to :resource_owner, class_name: 'User'

end
