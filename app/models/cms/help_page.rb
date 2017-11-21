class CMS::HelpPage < CMS::Content
  extend FriendlyId
  friendly_id :title, use: [:slugged, :scoped], scope: :type

  belongs_to :category, class_name: 'CMS::HelpCategory'

  has_closure_tree

  validates :title, :author_id, :category_id, :content, presence: true

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end