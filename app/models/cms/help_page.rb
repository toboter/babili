class CMS::HelpPage < CMS::Content
  before_validation :set_slug
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :scoped], scope: :type

  belongs_to :category, class_name: 'CMS::HelpCategory'

  has_closure_tree

  jsonb_accessor :type_details,
    abstract: :text

  validates :title, :author_id, :category_id, :abstract, presence: true

  def set_slug
    self.slug = slug.present? ? slug : title
  end
end