class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :author, class_name: 'User'
  
  validates :type, presence: true
  
  def self.types
    %w(About Post Novelity)
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end
