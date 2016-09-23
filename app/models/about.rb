class About < Blog
  validates :title, :author_id, :content, presence: true
end