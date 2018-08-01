class RepositorySerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :repository

  attributes :name, :full_name, :id, :url, :html_url, :data, :bibliography_url, :owner, :creator, :description, :topics, :created_at, :updated_at

  has_one :creator
  has_one :owner

  def full_name
    object.name_tree.join('/')
  end

  def owner
    object.owner.subclass
  end

  def data
    {
      events_url: events_url,
      items_url: items_url
    }
  end

  def events_url
    api_namespace_repository_aggregation_events_url(object.owner, object)
  end

  def items_url
    api_namespace_repository_aggregation_items_url(object.owner, object)
  end

  def bibliography_url
    api_namespace_repository_biblio_references_url(object.owner, object)
  end

  def url
    api_namespace_repository_url(object.owner, object)
  end

  def html_url
    namespace_repository_url(object.owner, object)
  end

  def topics
    object.topic_list
  end

end