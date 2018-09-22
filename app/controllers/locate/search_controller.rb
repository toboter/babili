class Locate::SearchController < ApplicationController

  def index
    set_meta_tags title: 'Search | Locate',
                  description: "Search results page for Locate",
                  noindex: true,
                  follow: true
    @results = Searchkick.search(params[:q], 
      fields: [:type, :description, :name, :datings], 
      index_name: [Locate::Place],
      indices_boost: {Locate::Place => 2})

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end

end