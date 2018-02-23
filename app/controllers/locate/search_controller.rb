class Locate::SearchController < ApplicationController

  def index
    @results = Searchkick.search(params[:q], 
      fields: [:name, :type, :description, :datings], 
      index_name: [Locate::Place],
      indices_boost: {Locate::Place => 2})

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end