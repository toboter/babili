class Vocab::SchemeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :scheme

  attribute :slug, key: :id
  attributes :abbr, :title, :definition

  attribute :url do
    api_vocab_scheme_url(object)
  end

  attribute :html_url do
    vocab_scheme_url(object)
  end

  attribute :creator do
    {
      name: object.creator.name,
      html_url: profile_url(object.creator.profile)
    }
  end



end