class Aggregation::CommitSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :commit

  attributes :id, :url, :html_url, :item, :event
  attribute :data_format do
    object.type.demodulize
  end
  attribute :data
  attribute :creator, key: :author

  def url
    api_namespace_repository_aggregation_item_commit_url(object.item.repository.owner, object.item.repository, object.item, object)
  end

  def html_url
    namespace_repository_aggregation_item_commit_url(object.item.repository.owner, object.item.repository, object.item, object)
  end

  belongs_to :item
  belongs_to :event
  belongs_to :creator, key: :author



end