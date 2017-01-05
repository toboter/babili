class Search::Accessibility < ApplicationRecord
  belongs_to :application, class_name: 'Search::Application'
  belongs_to :project
  
  validates :access, presence: true
  
 
end
