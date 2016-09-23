class Blog < ApplicationRecord
  belongs_to :author, class_name: 'User'
  
  validates :type, presence: true
  
  def self.types
    %w(About Post Novelity)
  end
end
