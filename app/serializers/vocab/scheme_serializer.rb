class Vocab::SchemeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :scheme

  attribute :slug, key: :id
  attributes :abbr, :title, :definition

  attribute :url do
    api_namespace_vocab_scheme_url(object.namespace, object)
  end

  attribute :html_url do
    namespace_vocab_scheme_url(object.namespace, object)
  end

  attribute :creator do
    {
      name: object.creator.name,
      html_url: namespace_url(object.creator.namespace)
    }
  end

  attribute :namespace do
    {
      name: object.namespace.name,
      html_url: namespace_url(object.namespace)
    }
  end


end