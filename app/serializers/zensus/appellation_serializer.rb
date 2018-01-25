class Zensus::AppellationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute :id

  attribute :name

  attribute :full_name do
    object.name(prefix: true, suffix: true, preferred: false)
  end

  attribute :name_elements do
    object.appellation_parts.map{ |p| {p.type.downcase.to_sym => p.body} }
  end

  attributes :language, :period, :trans

end