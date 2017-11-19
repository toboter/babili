class CMS::HelpCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  has_many :help_pages, foreign_key: 'category_id'

  validates :name, presence: true
end
