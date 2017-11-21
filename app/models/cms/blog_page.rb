class CMS::BlogPage < CMS::Content
  extend FriendlyId
  friendly_id :identifier_and_title, use: [:slugged, :scoped, :history], scope: :type

  belongs_to :category, class_name: 'BlogCategory'
  
  jsonb_accessor :type_details,
    featured: :boolean

  validates :title, :author_id, :content, :category_id, presence: true

  def identifier_and_title
    "#{self.new_record? ? Date.today.to_s : created_at.to_date.to_s}-#{title}"
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end