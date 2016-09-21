class Search::Application < ApplicationRecord
  validates :name, :search_url, :host, presence: true
  
  def url
    "#{host}#{search_url}"
  end
end
