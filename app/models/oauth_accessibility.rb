class OauthAccessibility < ApplicationRecord
  attr_accessor :accessor_gid

  belongs_to :oauth_application, class_name: 'Doorkeeper::Application', foreign_key: 'oauth_application_id'
  belongs_to :accessor, polymorphic: true # Person, Organization
  belongs_to :creator, class_name: "Person"

  validates :oauth_application_id, :accessor_id, :accessor_type, :creator_id, presence: true
  validates :oauth_application_id, uniqueness: { scope: [:accessor_id, :accessor_type] }

  def accessor_gid=(gid)
    self.accessor = GlobalID::Locator.locate(gid)
  end

end
