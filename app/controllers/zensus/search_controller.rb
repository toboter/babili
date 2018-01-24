class Zensus::SearchController < ApplicationController

  def index
    @results = Searchkick.search(params[:q], 
      fields: ['name^10', :appellations, :activities, 'description^2', :date, :related_events], 
      index_name: [Zensus::Agent, Zensus::Event],
      indices_boost: {Zensus::Agent => 2, Zensus::Event => 1})

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end