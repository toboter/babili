class CMS::Novelity < CMS::Content
  extend FriendlyId
  friendly_id :title, :use => :scoped, :scope => :type
  
  validates :title, presence: true

  
end