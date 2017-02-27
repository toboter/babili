class Project < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :description, presence: true
  
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user
  has_many :oread_accessibilities, dependent: :delete_all
  has_many :oread_applications, through: :oread_accessibilities
  has_many :oread_application_ownerships, class_name: 'Oread::Application', as: :owner
  has_many :oauth_accessibilities, dependent: :delete_all
  has_many :oauth_applications, through: :oauth_accessibilities
  has_many :oauth_application_ownerships, class_name: 'Doorkeeper::Application', as: :owner

  def has_owner?
    memberships.where(role: 'Owner').any?
  end
  
  def owner
    memberships.where(role: 'Owner').first.user
  end
  
end
