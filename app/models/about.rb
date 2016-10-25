class About < Blog
  acts_as_list
  validates :title, :author_id, :content, presence: true
end