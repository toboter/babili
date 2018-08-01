class Aggregation::EventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :event

  attribute :slug, key: :name
  attributes :id, :url, :html_url, :commits_url, :commits_count
  attribute :note, key: :message
  attribute :commited_at
  attribute :creator
  attribute :repository
  attributes :created_at, :updated_at

  def url
    api_namespace_repository_aggregation_event_url(object.repository.owner, object.repository, object)
  end

  def html_url
    namespace_repository_aggregation_event_url(object.repository.owner, object.repository, object)
  end

  def boi_url
    api_identifier_url(object.identifiers.first)
  end

  def commits_url
    api_namespace_repository_aggregation_event_commits_url(object.repository.owner, object.repository, object)
  end

  def commits_count
    object.commits.count
  end

  belongs_to :creator
  belongs_to :repository

end