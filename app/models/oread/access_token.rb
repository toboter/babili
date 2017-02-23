class Oread::AccessToken < ApplicationRecord
  self.table_name = :oread_access_tokens
  
  belongs_to :application, class_name: 'Oread::Application'
  belongs_to :resource_owner, class_name: 'User', foreign_key: 'resource_owner_id'

  validates :resource_owner_id, :token, presence: true
end
