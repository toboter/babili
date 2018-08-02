class PersonalAccessToken < ApplicationRecord
  include AttrJson::Record
  include AttrJson::Record::QueryScopes

  has_secure_token :access_token

  self.default_json_container_attribute = 'scope'
  attr_json :collections, :boolean
  attr_json :search, :boolean
  attr_json :notifications, :boolean
  attr_json :organizations, :boolean
  attr_json :user_profile, :boolean
  attr_json :user_email, :boolean

  validates :resource_owner_id, :description, presence: true

  belongs_to :resource_owner, class_name: 'User'

end
