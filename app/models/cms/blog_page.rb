class CMS::BlogPage < CMS::Content
  # evtl gibt es einen Fehler in CanCan, der verhindert, dass die history durchsucht werden kann.
  extend FriendlyId
  friendly_id :date_with_title, use: [:slugged, :scoped, :history], scope: :type

  belongs_to :category, class_name: 'BlogCategory'
  
  jsonb_accessor :type_details,
    featured: :boolean

  validates :title, :author_id, :content, :category_id, presence: true

  scope :featured, -> { type_details_where(featured: true) }
  scope :unpublished, -> { where(published_at: nil) }

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