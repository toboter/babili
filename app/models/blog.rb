class Blog < ApplicationRecord
  # mount_uploaders :images, ImageUploader
  
  belongs_to :author, class_name: 'User'
  
  validates :type, :title, :author_id, presence: true
  
  def self.types
    %w(About Post Novelity)
  end
end
