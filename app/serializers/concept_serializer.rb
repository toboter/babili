class ConceptSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  type :concept

  attribute :slug, key: :id
  attribute :status
  attribute :name, key: :default_label
  attribute :url do
    v1_namespace_vocab_scheme_concept_url(object.scheme.namespace, object.scheme, object)
  end

  attribute :html_url do
    namespace_vocab_scheme_concept_url(object.scheme.namespace, object.scheme, object)
  end

  attributes :created_at, :updated_at

  attribute :creator do
    {
      name: object.creator.name,
      url: v1_person_url(object.creator),
      html_url: namespace_url(object.creator.namespace)
    }
  end

  attribute :contributors do
    object.contributors.map do |contrib|
      {
        name: contrib.name,
        url: v1_person_url(contrib),
        html_url: namespace_url(contrib.namespace)
      }
    end
  end

  attribute :broader do
    object.broader_concepts.map do |concept| 
      {
        default_label: concept.name, 
        url: v1_namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept),
        html_url: namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept)
      }
    end
  end

  attribute :narrower do
    object.narrower_concepts.map do |concept| 
      {
        default_label: concept.name, 
        url: v1_namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept),
        html_url: namespace_vocab_scheme_concept_url(concept.scheme.namespace, concept.scheme, concept)
      }
    end
  end

  has_many :notes
  has_many :labels

  attribute :relations do
    object.ext_matches + object.loc_matches
  end
  attribute :matches do
    object.matches.map do |match|
      {
        property: match.property,
        url: object.api_uri
      }
    end
  end

end
