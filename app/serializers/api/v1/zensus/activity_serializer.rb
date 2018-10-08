module Api::V1::Zensus
  class ActivitySerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attribute :html_url do
      zensus_event_activity_url(object.event, object)
    end

    attribute :actable, key: :actor do
      object.actable.default_name
    end

    attribute :actor_url do
      v1_zensus_agent_url(object.actable)
    end

    attribute :property do
      object.name(inverse: true)
    end

    attribute :event do
      object.event.title
    end
    attribute :event_url do
      v1_zensus_event_url(object.event)
    end

  end
end