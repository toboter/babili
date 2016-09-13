class Search::Application < ApplicationRecord
  validates :name, :search_url, :host, presence: true
end
