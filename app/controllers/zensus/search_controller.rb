class Zensus::SearchController < ApplicationController

  def index
    set_meta_tags title: 'Search | Zensus',
                  description: "Search results page for Zensus",
                  noindex: true,
                  follow: true
    @results = Searchkick.search(params[:q], 
      fields: ['name^10', :appellations, :activities, 'description^2', :begins_at, :ends_at, :related_events, :agent], 
      index_name: [Zensus::Agent, Zensus::Appellation, Zensus::Event],
      indices_boost: {Zensus::Agent => 4, Zensus::Appellation => 2, Zensus::Event => 1})

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end