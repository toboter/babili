class Zensus::EventSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :event

  attributes :id, :title, :begins_at
  attribute :ends_at do
    object.ends_at(full: true)
  end
  attribute :url do
    api_zensus_event_url(object.id)
  end

  attribute :html_url do
    zensus_event_url(object)
  end

  attributes :created_at, :updated_at

  has_many :activities, each_serializer: Zensus::ActivitySerializer

end