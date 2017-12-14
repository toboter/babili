class RepositoryClass < ApplicationRecord
  belongs_to :repository, class_name: 'Oread::Application', foreign_key: :repository_id
  validates :repo_api_url, presence: true
end
