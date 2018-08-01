class Aggregation::ItemSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :item

  attributes :name, :id, :url, :html_url, :boi_url, :commits_url, :revisions, :first_commit, :last_commit, :last_commit_url
  attribute :repository

  def url
    api_namespace_repository_aggregation_item_url(object.repository.owner, object.repository, object)
  end

  def html_url
    namespace_repository_aggregation_item_url(object.repository.owner, object.repository, object)
  end

  def boi_url
    api_identifier_url(object.identifiers.first)
  end

  def commits_url
    api_namespace_repository_aggregation_item_commits_url(object.repository.owner, object.repository, object)
  end

  def last_commit
    object.commits.last.try(:created_at)
  end

  def last_commit_url
    object.commits.any? ? api_namespace_repository_aggregation_item_commit_url(object.repository.owner, object.repository, object, object.commits.last) : nil
  end

  def first_commit
    object.commits.first.try(:created_at)
  end

  def revisions
    object.commits.count
  end

  belongs_to :repository


end