class CMS::BlogPage < CMS::Content
  include JsonAttribute::Record
  include JsonAttribute::Record::QueryScopes
  # evtl gibt es einen Fehler in CanCan, der verhindert, dass die history durchsucht werden kann.
  extend FriendlyId
  friendly_id :date_with_title, use: [:slugged, :scoped, :history], scope: :type

  self.default_json_container_attribute = 'type_details'
  json_attribute :featured, :boolean

  belongs_to :category, class_name: 'BlogCategory'

  validates :title, :author_id, :content, :category_id, presence: true

  scope :featured, -> { jsonb_contains(featured: true) }
  scope :unpublished, -> { where(published_at: nil) }
  scope :published, -> { where.not(published_at: nil) }

  def date_with_title
    "#{self.new_record? ? Date.today.to_s : created_at.to_date.to_s}-#{title}"
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def has_author?(person)
    author == person
  end

  def published?
    published_at.present?
  end

  def featured?
    type_details_where(featured: true)
  end



end