class Vocab::SearchController < ApplicationController

  def terms
    @aat_terms = Vocab::AAT.search(params[:q]) if params[:q]
    @aat_terms = @aat_terms.map{|t| {id: t['Subject'].to_s, name: t['Term'].to_s, parents: t['Parents'].to_s, note: t['ScopeNote'].to_s } }
    @local_terms = Vocab::Concept.all.search(params[:q]) if params[:q]
    @local_terms = @local_terms.map{|t| { id: url_for([:vocab, t.scheme, t]), name: t.name, parents: t.ancestors.map(&:name).join(', '), note: t.definitions.first.body } }
    render json: @aat_terms.concat(@local_terms)
  end



end