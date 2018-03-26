class CMS::HelpPage < CMS::Content
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes

  before_validation :set_slug
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :scoped], scope: :type

  self.default_json_container_attribute = 'type_details'
  json_attribute :abstract, :string

  belongs_to :category, class_name: 'CMS::HelpCategory'

  has_closure_tree

  validates :title, :author_id, :category_id, :abstract, presence: true

  def set_slug
    self.slug = slug.present? ? slug : title
  end
end