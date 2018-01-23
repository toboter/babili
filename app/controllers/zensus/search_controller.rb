class Zensus::SearchController < ApplicationController

  def index
    @results = Zensus::Agent.search(params[:q], fields: ['name^10', :appellations, :events, :activities])

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end