class CMS::Content < ApplicationRecord
  belongs_to :author, class_name: 'User'
  
  validates :type, presence: true
  
  def self.types
    %w[CMS::Blog CMS::HelpPage CMS::Novelity]
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end