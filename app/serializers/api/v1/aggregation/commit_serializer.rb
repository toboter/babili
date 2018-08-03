module Api::V1::Aggregation
  class CommitSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :commit

    attributes :id, :url, :html_url, :item_url, :event_url
    attribute :data_format do
      object.type.demodulize
    end
    attribute :data
    attribute :author_url

    def url
      v1_namespace_repository_aggregation_item_commit_url(object.item.repository.owner, object.item.repository, object.item, object)
    end

    def html_url
      namespace_repository_aggregation_item_commit_url(object.item.repository.owner, object.item.repository, object.item, object)
    end

    def item_url
      v1_namespace_repository_aggregation_item_url(object.item.repository.owner, object.item.repository, object.item)
    end

    def event_url
      v1_namespace_repository_aggregation_event_url(object.event.repository.owner, object.event.repository, object.event)
    end

    def author_url
      v1_person_url(object.creator)
    end


  end
end