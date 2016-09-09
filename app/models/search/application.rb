class Search::Application < ApplicationRecord
  validates :name, :search_url, presence: true
end
