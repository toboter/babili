class Project < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :description, presence: true
  
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user

  has_many :oauth_accessibilities, as: :accessor, dependent: :delete_all
  has_many :oauth_applications, through: :oauth_accessibilities
  has_many :oauth_application_ownerships, class_name: 'Doorkeeper::Application', as: :owner

  accepts_nested_attributes_for :memberships, reject_if: :all_blank, allow_destroy: true

  def has_owner?
    memberships.where(role: 'Owner').any?
  end
  
  def owner
    members.where(memberships: {role: 'Owner'})
  end

  def accessible
    [id, self.class.name].join(",")
  end

end
