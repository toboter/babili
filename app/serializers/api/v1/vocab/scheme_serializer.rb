module Api::V1::Vocab
  class SchemeSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :concept_scheme
    attribute(:@context) { "https://github.com/babylon-online/schema/raw/master/contexts/concept_scheme.jsonld" }

    attribute(:schema) { 'https://github.com/babylon-online/schema/raw/master/concept_scheme.json' }
    attribute :id do
      [object.namespace.name, 'vocabulary', 'schemes', object.slug].join('/')
    end
    attribute(:created) { object.created_at }
    attribute :creator do
      person_variable(object.creator)
    end
    attribute :contributors do
      object.contributors.map do |c|
        person_variable(c)
      end
    end

    attribute :title do
      { de: object.title }
    end
    attribute :note do
      { de: object.definition }
    end

    attribute :hasTopConcepts do
      object.concepts.roots.map do |concept|
        {
          id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          facet: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          inScheme: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug].join('/')
        }
      end
    end

    attribute :links do
      {
        self: v1_namespace_vocab_scheme_url(object.namespace, object),
        html: namespace_vocab_scheme_url(object.namespace, object)
      }
    end



    def person_variable(person)
      {
        name: person.name,
        personData: {
          id: person.namespace.name,
          name: {
            family: person.try(:family_name),
            given: person.try(:given_name)
          },
          about: {
            de: person.try(:about_me)
          }
        }
      }
    end

  end
end
