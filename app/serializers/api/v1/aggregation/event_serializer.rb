module Api::V1::Aggregation
  class EventSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :event

    attribute :slug, key: :name
    attributes :id, :url, :html_url, :commits_url, :commits_count, :repository_url, :creator_url
    attribute :note, key: :message
    attribute :commited_at
    attributes :created_at, :updated_at

    def url
      v1_namespace_repository_aggregation_event_url(object.repository.owner, object.repository, object)
    end

    def html_url
      namespace_repository_aggregation_event_url(object.repository.owner, object.repository, object)
    end

    def boi_url
      v1_identifier_url(object.identifiers.first)
    end

    def commits_url
      v1_namespace_repository_aggregation_event_commits_url(object.repository.owner, object.repository, object)
    end

    def commits_count
      object.commits.count
    end

    def repository_url
      v1_namespace_repository_url(object.repository.owner, object.repository)
    end

    def creator_url
      v1_person_url(object.creator)
    end

  end
end