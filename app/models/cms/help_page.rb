class CMS::HelpPage < CMS::Content
  extend FriendlyId
  friendly_id :title, :use => :scoped, :scope => :type

  belongs_to :category, class_name: 'HelpCategory'

  has_closure_tree

  validates :title, :author_id, :category_id, :content, presence: true
end