class Search::Application < ApplicationRecord
  mount_uploader :image, SearchApplicationUploader
  
  validates :name, :search_url, :host, presence: true
  
  belongs_to :oauth_application, class_name: 'Doorkeeper::Application'
  has_many :accessibilities, dependent: :destroy, class_name: 'Search::Accessibility'
  has_many :projects, through: :accessibilities, class_name: 'Project'
  
  def url
    "#{host}#{search_url}"
  end
end
