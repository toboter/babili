module Api::V1::Vocab
  class ConceptSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    type :concept
    attribute(:@context) { "https://github.com/babylon-online/schema/raw/master/contexts/concept.jsonld" }

    attribute(:schema) { 'https://github.com/babylon-online/schema/raw/master/concept.json' }
    attribute(:id) { [object.scheme.namespace.name, 'vocabulary', 'schemes', object.scheme.slug, 'concepts', object.slug].join('/') }

    attribute(:created) { object.created_at }
    attribute(:issued) { object.created_at }
    attribute(:modified) { object.updated_at }
    attribute :status

    attribute :creator do
      person_variable(object.creator)
    end
    attribute :contributors do
      object.contributors.map do |c|
        person_variable(c)
      end
    end
    attribute(:publisher) { person_variable(object.creator) }

    attribute :inScheme do
      {
        id: [object.scheme.namespace.name, 'vocabulary', 'schemes', object.scheme.slug].join('/'),
        title: { de: object.scheme.title },
        hasTopConcepts: object.scheme.concepts.roots.map{ |concept|
          {
            id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
            prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          }
        }
      }
    end
    attribute :topConceptOf, if: -> { object.root? } do
      {
        id: [object.scheme.namespace.name, 'vocabulary', 'schemes', object.scheme.slug].join('/'),
        title: { de: object.scheme.title },
        hasTopConcepts: object.scheme.concepts.roots.map{ |concept|
          {
            id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
            prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          }
        }
      }
    end
    attribute :facet, unless: -> { object.root? } do
      object.ancestors.roots.map do |concept|
        {
          id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          inScheme: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug].join('/')
        }
      end
    end

    attribute(:prefLabel) { object.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!) }
    attribute(:altLabel) { object.labels.where(type: 'Alternative', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!) }
    attribute(:hiddenLabel) { object.labels.where(type: 'Hidden', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!) }

    attribute :broader do
      object.broader_concepts.map do |concept|
        {
          id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          facet: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          inScheme: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug].join('/')
        }
      end
    end
    attribute :narrower do
      object.narrower_concepts.map do |concept|
        {
          id: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          prefLabel: concept.labels.where(type: 'Preferred', is_abbrevation: false).map{ |label| {LanguageList::LanguageInfo.find(label.language.split(' ').last).iso_639_1.to_sym => label.body} }.reduce(&:merge!),
          facet: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug, 'concepts', concept.slug].join('/'),
          inScheme: [concept.scheme.namespace.name, 'vocabulary', 'schemes', concept.scheme.slug].join('/')
        }
      end
    end
    attribute :related do
      {}
    end
    attribute :broaderTransitive do
      {}
    end
    attribute :narrowerTransitive do
      {}
    end

    attribute(:scopeNote) { object.notes.where(type: 'Scope').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }
    attribute(:definition) { object.notes.where(type: 'Definition').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }
    attribute(:example) { object.notes.where(type: 'Example').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }
    attribute(:historyNote) { object.notes.where(type: 'History').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }
    attribute(:editoialNote) { object.notes.where(type: 'Editorial').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }
    attribute(:changeNote) { object.notes.where(type: 'Change').map{ |note| {LanguageList::LanguageInfo.find(note.language.split(' ').last).iso_639_1.to_sym => note.body} }.reduce(&:merge!) }


    attribute(:closeMatch) { object.matches.where(property: 'close').map{|m| {name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable } }
    attribute(:exactMatch) { object.matches.where(property: 'exact').map{|m| {name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable } }
    attribute(:relatedMatch) { object.matches.where(property: 'related').map{|m| {name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable } }
    attribute(:broadMatch) { object.matches.where(property: 'broader').map{|m| {name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable } }
    attribute(:narrowMatch) { object.matches.where(property: 'narrower').map{|m| {name: m.associatable.try(:name), uri: m.associatable.api_uri } if m.associatable } }

    attribute :links do
      {
        self: v1_namespace_vocab_scheme_concept_url(object.scheme.namespace, object.scheme, object),
        html: namespace_vocab_scheme_concept_url(object.scheme.namespace, object.scheme, object)
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
