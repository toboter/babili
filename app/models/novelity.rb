class Novelity < Blog
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  validates :title, :external_link, :posted_at, presence: true
  validates :external_link, uniqueness: true
  
end