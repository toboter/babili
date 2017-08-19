class About < Blog
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  acts_as_list
  validates :title, :author_id, :content, presence: true
end