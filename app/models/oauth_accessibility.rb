class OauthAccessibility < ApplicationRecord
  belongs_to :oauth_application, class_name: 'Doorkeeper::Application', foreign_key: 'oauth_application_id'
  belongs_to :accessor, polymorphic: true

  validates :oauth_application_id, :accessor_id, :accessor_type, :creator_id, presence: true
  validates :oauth_application_id, uniqueness: { scope: [:accessor_id, :accessor_type] }

  def accessor=(attribute)
    self.accessor_id, self.accessor_type = attribute.split(',')
  end
end
