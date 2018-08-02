class CMS::HelpPage < CMS::Content
  include AttrJson::Record
  include AttrJson::Record::QueryScopes

  before_validation :set_slug
  extend FriendlyId
  friendly_id :slug, use: [:slugged, :scoped], scope: :type

  attr_json_config(default_container_attribute: :type_details)
  attr_json :abstract, :string

  belongs_to :category, class_name: 'CMS::HelpCategory'

  has_closure_tree

  validates :title, :author_id, :category_id, :abstract, presence: true

  def set_slug
    self.slug = slug.present? ? slug : title
  end
end