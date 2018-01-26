class Vocab::SearchController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @results = Searchkick.search(params[:q], 
      fields: [:type, 'narrower^4', :scheme, 'labels^10', :broader, :notes], 
      index_name: [Vocab::Concept],
      indices_boost: {Vocab::Concept => 2})

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

  def terms
    @aat_terms = Vocab::AATConcept.search(params[:q]) if params[:q]
    @aat_terms = @aat_terms.map{|t| {id: t['Subject'].to_s, name: t['Term'].to_s, parents: t['Parents'].to_s, note: truncate(t['ScopeNote'].to_s, length: 100) } }
    @local_terms = Vocab::Concept.all.search(params[:q]) if params[:q]
    @local_terms = @local_terms.map{|t| { id: url_for([:vocab, t.scheme, t]), name: t.name, parents: t.ancestors.map(&:name).join(', '), note: truncate(t.definitions.first.body, length: 100) } }
    render json: @aat_terms.concat(@local_terms)
  end



end