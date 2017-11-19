class CMS::BlogPage < CMS::Content
  extend FriendlyId
  friendly_id :ident_title, :use => :scoped, :scope => :type

  belongs_to :category, class_name: 'BlogCategory'
  
  jsonb_accessor :type_details,
    featured: :boolean

  validates :title, :author_id, :content, :category_id, presence: true

  def ident_title
    "#{id}-#{title}"
  end
end