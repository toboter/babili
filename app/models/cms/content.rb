class CMS::Content < ApplicationRecord
  extend FriendlyId
  friendly_id :slug
  
  belongs_to :author, class_name: 'User'
  
  validates :type, presence: true
  
  def self.types
    %w[CMS::Blog CMS::HelpPage CMS::Novelity]
  end

end