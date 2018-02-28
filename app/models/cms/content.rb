class CMS::Content < ApplicationRecord
  extend FriendlyId
  
  belongs_to :author, class_name: 'Person'
  
  validates :type, presence: true
  
  def self.types
    %w[CMS::Blog CMS::HelpPage CMS::Novelity]
  end

end