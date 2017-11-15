class PersonalAccessToken < ApplicationRecord
  has_secure_token :access_token

  jsonb_accessor :scope,
    collections: :boolean,
    search: :boolean,
    notifications: :boolean,
    projects: :boolean,
    user_profile: :boolean,
    user_email: :boolean

  validates :resource_owner_id, :description, presence: true

  belongs_to :resource_owner, class_name: 'User'

end
