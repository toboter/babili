class Organization < ApplicationRecord
  include ImageUploader[:image]
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'Person', source: :person
  has_many :oauth_accessibilities, as: :accessor, dependent: :delete_all
  has_many :accessible_oauth_apps, through: :oauth_accessibilities, source: :oauth_application
  has_many :users, through: :members
  
  accepts_nested_attributes_for :memberships, reject_if: :all_blank, allow_destroy: true

  validates :name, :description, presence: true

  def has_admin?
    memberships.where(role: 'Admin').any?
  end
  
  def admins
    members.where(memberships: {role: 'Admin'})
  end

  def has_admin?(person)
    members.where(memberships: {role: 'Admin'}).include?(person)
  end

end
