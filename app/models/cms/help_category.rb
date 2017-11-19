class CMS::HelpCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, :use => :slugged

  acts_as_list
  
  has_many :help_pages, foreign_key: 'category_id'

  validates :name, presence: true
end
