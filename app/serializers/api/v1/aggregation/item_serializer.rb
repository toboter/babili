module Api::V1::Aggregation
  class ItemSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :item

    attributes :name, :id, :url, :html_url, :boi_url, :commits_url, :revisions, :first_commit, :last_commit, :last_commit_url
    attribute :repository_url

    def url
      v1_namespace_repository_aggregation_item_url(object.repository.owner, object.repository, object)
    end

    def html_url
      namespace_repository_aggregation_item_url(object.repository.owner, object.repository, object)
    end

    def boi_url
      v1_identifier_url(object.identifiers.first)
    end

    def commits_url
      v1_namespace_repository_aggregation_item_commits_url(object.repository.owner, object.repository, object)
    end

    def last_commit
      object.commits.last.try(:created_at)
    end

    def last_commit_url
      object.commits.any? ? v1_namespace_repository_aggregation_item_commit_url(object.repository.owner, object.repository, object, object.commits.last) : nil
    end

    def first_commit
      object.commits.first.try(:created_at)
    end

    def revisions
      object.commits.count
    end

    def repository_url
      v1_namespace_repository_url(object.repository.owner, object.repository)
    end


  end
end