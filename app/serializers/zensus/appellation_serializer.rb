class Zensus::AppellationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :name

  attribute :id

  attribute :name

  attribute :full_name do
    object.name(prefix: true, suffix: true, preferred: false)
  end

  attribute :url do
    api_zensus_name_url(object)
  end

  attribute :html_url do
    zensus_name_url(object)
  end

  attribute :name_elements do
    object.appellation_parts.map{ |p| {p.type.downcase.to_sym => p.body} }
  end

  attributes :language, :period, :trans

  attribute :agent do
    {
      url: api_zensus_agent_url(object.agent), 
      default_name: object.agent.default_name
    } if object.agent
  end

  attributes :created_at, :updated_at

end