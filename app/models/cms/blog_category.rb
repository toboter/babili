class CMS::BlogCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :blog_pages, foreign_key: 'category_id'

  validates :name, presence: true
end
