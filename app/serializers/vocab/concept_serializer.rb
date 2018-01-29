class Vocab::ConceptSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :concept

  attribute :slug, key: :id
  attribute :status
  attribute :name, key: :default_label
  attribute :url do
    api_vocab_scheme_concept_url(object.scheme, object)
  end

  attribute :html_url do
    vocab_scheme_concept_url(object.scheme, object)
  end

  attributes :created_at, :updated_at

  attribute :creator do
    {
      name: object.creator.name,
      url: api_user_url(object.creator),
      html_url: profile_url(object.creator.profile)
    }
  end

  attribute :contributors do
    object.contributors.map do |contrib|
      {
        name: contrib.name,
        url: api_user_url(contrib),
        html_url: profile_url(contrib.profile)
      }
    end
  end

  attribute :broader do
    object.broader_concepts.map do |concept| 
      {
        default_label: concept.name, 
        url: api_vocab_scheme_concept_url(concept.scheme, concept),
        html_url: vocab_scheme_concept_url(concept.scheme, concept)
      }
    end
  end

  attribute :narrower do
    object.narrower_concepts.map do |concept| 
      {
        default_label: concept.name, 
        url: api_vocab_scheme_concept_url(concept.scheme, concept),
        html_url: vocab_scheme_concept_url(concept.scheme, concept)
      }
    end
  end

  attribute :matches do
    object.matches.map do |match|
      {
        property: match.property,
        url: object.api_uri
      }
    end
  end

  has_many :notes
  has_many :labels
  belongs_to :scheme, key: :in_scheme

end