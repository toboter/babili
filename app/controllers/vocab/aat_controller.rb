class Vocab::AATController < ApplicationController
  before_action :set_language

  def index
    @scheme = Vocab::Scheme.find_by_abbr('aat')
    @concepts = Vocab::AATConcept.facets(@language)
    render 'vocab/concepts/index'
  end

  def show
    @concept = Vocab::AATConcept.find(params[:id], @language)
  end

  private
  def set_language
    @language = LanguageList::LanguageInfo.find(browser.accept_language.first.part.split('-').first)
  end
  
end