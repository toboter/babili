class Project < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  validates :name, :description, presence: true
  
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user
  has_many :accessibilities, dependent: :destroy, class_name: 'Search::Accessibility'
  has_many :applications, through: :accessibilities, class_name: 'Search::Application'
  
  def has_owner?
    memberships.where(role: 'Owner').any?
  end
  
end
