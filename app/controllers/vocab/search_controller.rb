require "timeout"

class Vocab::SearchController < ApplicationController
  include ActionView::Helpers::TextHelper

  TERMS_LIMIT = 10

  def index
    set_meta_tags title: 'Search | Concepts | Vocabularies',
                  description: "Search for all concepts in all schemes",
                  noindex: true,
                  follow: true

    @results = Searchkick.search(params[:q],
      fields: [:type, 'narrower^4', :scheme, 'labels^10', :broader, :notes, :matches],
      index_name: [Vocab::Concept],
      indices_boost: {Vocab::Concept => 2})

    respond_to do |format|
      format.html
      # Searchkick::Relation#to_json dumps the query object — materialize hits.
      format.json { render json: Array(@results) }
    end
  end

  def terms
    terms = []

    if params[:q].present?
      local = Vocab::Concept.search(
        params[:q],
        fields: ['labels^10', :broader, :notes],
        limit: TERMS_LIMIT,
        load: true
      )
      terms.concat(
        Array(local).first(TERMS_LIMIT).map { |t|
          {
            id: [t.to_global_id.to_s, t.name],
            name: t.name,
            parents: t.ancestors.map(&:name).join(', '),
            note: truncate(t.definitions.first&.body.to_s, length: 100)
          }
        }
      )

      # Getty AAT SPARQL is often slow/unreachable — never block local tag suggestions.
      begin
        aat = Timeout.timeout(2) { Vocab::AATConcept.search(params[:q]) }
        terms.concat(
          Array(aat).first(TERMS_LIMIT).map { |t|
            {
              id: [t['Subject'].to_s, t['Term'].to_s],
              name: t['Term'].to_s,
              parents: t['Parents'].to_s,
              note: truncate(t['ScopeNote'].to_s, length: 100)
            }
          }
        )
      rescue StandardError => e
        Rails.logger.warn("[vocab/search#terms] AAT skipped: #{e.class}: #{e.message}")
      end
    end

    # Flat array for selectize (was nested [[local…],[aat…]]).
    render json: terms
  end
end
