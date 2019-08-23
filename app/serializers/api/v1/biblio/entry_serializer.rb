module Api::V1::Biblio
  class EntrySerializer < ActiveModel::Serializer
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::TextHelper
    include Rails.application.routes.url_helpers
    type :citation_data_item

    attribute(:schema) { 'https://github.com/toboter/schema/raw/master/citation_data_item.json' }
    attribute :type do
      type = object.type.demodulize
      case type
        when 'Book' then 'book'
        when 'Booklet' then 'book'
        when 'Collection' then 'book'
        when 'Proceeding' then 'book'
        when 'Article' then 'article-journal'
        when 'InBook' then 'chapter'
        when 'InCollection' then 'article'
        when 'InProceeding' then 'paper-conference'
        when 'Manual' then 'book'
        when 'Phd-Thesis' then 'thesis'
        when 'Masterthesis' then 'thesis'
        when 'Unpublished' then 'manuscript'
        when 'Techreport' then 'report'
        when 'Misc' then 'misc'
        else type.downcase
      end
    end

    attribute :slug, key: :id

    attribute :categories, if: -> { object.tags.any? } do
      object.tag_list
    end

    attribute(:language) { lang(object.title) }
    attribute(:journalAbbreviation, if: -> { object.type == 'Article' }) { object.try(:journal).try(:abbr) }
    attribute :citation, key: :shortTitle

    attribute :author, if: -> { object.class.method_defined?(:authors) } do
      object.authors.map{|a| person_variable(a)}
    end
    attribute :"collection-editor", if: -> { object.type != 'Biblio::Collection' && object.class.method_defined?(:editors) } do
      object.editors.map{|a| person_variable(a)}
    end
    attribute :"container-author", if: ->  { object.type == 'Biblio::InBook' } do
      object.book.authors.map{|a| person_variable(a)}
    end
    attribute :editor, if: -> { object.type == 'Biblio::Collection' && object.class.method_defined?(:editors) } do
      object.editors.map{|a| person_variable(a)}
    end

    attribute :container, if: -> { object.try(:parent).try(:year) } do
      {
        "date-parts": [object.try(:parent).try(:year), object.try(:parent).try(:month), object.try(:parent).try(:day)].reject { |e| e.to_s.empty? },
        literal: object.try(:parent).try(:year)
      }
    end
    attribute :issued do
      {
        "date-parts": [object.try(:year), object.try(:month), object.try(:day)].reject { |e| e.to_s.empty? },
        literal: object.year
      }
    end
    attribute :abstract, if: -> { object.class.method_defined?(:abstract) && object.abstract.present? }

    attribute :"container-title", if: -> { object.try(:parent) } do
      object.parent.type.in?(['Biblio::Serie', 'Biblio::Journal']) ? object.try(:parent).try(:name) : object.try(:parent).try(:title)
    end
    attribute :"container-title-short", if: -> { object.try(:parent).try(:abbr) } do
      object.try(:parent).try(:abbr)
    end

    attribute :doi, key: :DOI, if: -> { object.class.method_defined?(:doi) && object.doi.present? }
    attribute :isbn, key: :ISBN, if: -> {object.class.method_defined?(:isbn) && object.isbn.present?}
    attribute :issn, key: :ISSN, if: -> {object.class.method_defined?(:issn) && object.issn.present?}

    attribute :number, if: -> {object.class.method_defined?(:number) && object.number.present?}
    attribute(:"number-of-pages", if: -> {object.class.method_defined?(:pages) && object.pages.present?}) { (object.pages.split('-').last.to_i - object.pages.split('-').first.to_i).try(:to_s) }
    attribute(:"page-first", if: -> {object.class.method_defined?(:pages) && object.pages.present?}) { object.pages.split('-').first }
    attribute :pages, key: :page, if: -> {object.class.method_defined?(:pages) && object.pages.present?}

    attribute(:publisher, if: -> { object.class.method_defined?(:publisher) }) { object.try(:publisher).try(:name) }
    attribute :"publisher-place", if: -> { object.class.method_defined?(:places) } do 
      object.places.map { |p| p.try(:given) }.join(', ') if object.places.present?
    end

    attribute :title

    attribute :url, key: :URL, if: -> {object.class.method_defined?(:url) && object.url.present?}

    attribute :volume, if: -> {object.class.method_defined?(:volume) && object.volume.present?}


    attribute :links do
      {
        self: url_for([:v1, object]),
        html: url_for(object)
      }
    end

    attribute :cite do
      object.bibliographic unless object.type.in?(['Biblio::Serie', 'Biblio::Journal'])
    end


    def person_variable(person)
      {
        family: Namae.parse(person.name).try(:first).try(:family),
        given: Namae.parse(person.name).try(:first).try(:given),
        literal: person.name
      }
    end

    def lang(sample)
      d = WhatLanguage.new(:english, :german, :french)
      d.language_iso(sample)
    end

  end
end