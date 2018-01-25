class Zensus::AgentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :agent

  attribute :slug, key: :id
  attribute :default_name, key: :name
  attribute :type do
    object.type == 'Zensus::Person' ? 'Person' : 'Group'
  end

  attribute :url do
    api_zensus_agent_url(object.id)
  end

  attribute :html_url do
    zensus_agent_url(object)
  end

  attributes :created_at, :updated_at, :address

  has_many :activities
  has_many :appellations

end