class Novelity < Blog
  validates :title, :external_link, :posted_at, presence: true
  validates :external_link, uniqueness: true
  
end