class Search::Application < ApplicationRecord
  mount_uploader :image, SearchApplicationUploader
  
  validates :name, :search_url, :host, presence: true
  
  def url
    "#{host}#{search_url}"
  end
end
