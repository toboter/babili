class Oread::AccessToken < ApplicationRecord
  belongs_to :application, class_name: 'Oread::Application'
  belongs_to :resource_owner, class_name: 'User', foreign_key: 'resource_owner_id'

  validates :application_id, :resource_owner_id, :token, presence: true
end
