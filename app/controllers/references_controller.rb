class ReferencesController < ApplicationController
  authorize_resource :reference, class: false

  def referenceables
    query = params[:q].to_s.strip
    indexes = [Vocab::Concept, Biblio::Entry, Discussion::Thread, Writer::Document]
    @referenceables =
      if query.present?
        Searchkick.search(query, index_name: indexes, limit: 20, load: true)
      else
        # Prefer recent/name-ordered samples per type when the picker first opens.
        (
          Vocab::Concept.order(updated_at: :desc).limit(5).to_a +
          Biblio::Entry.order(updated_at: :desc).limit(5).to_a +
          Discussion::Thread.order(updated_at: :desc).limit(5).to_a +
          Writer::Document.order(updated_at: :desc).limit(5).to_a
        ).first(20)
      end
    render template: "references/referenceables"
  end
end
